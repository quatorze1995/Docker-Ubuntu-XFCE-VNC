#!/bin/bash
echo "Starting container initialization..."

VNC_RESOLUTION=${RESOLUTION:-"1600x900"}
VNC_PASSWORD=${VNC_PASSWORD:-"password"}
echo "Setting up VNC with Resolution: $VNC_RESOLUTION and Password: $VNC_PASSWORD..."

export USER=root

if [ ! -f /root/.Xresources ]; then
    echo "Creating a default '/root/.Xresources' with basic customization..."
    echo "*customization: -color" > /root/.Xresources
else
    echo "Found existing '/root/.Xresources'. No changes made."
fi

echo "Ensuring VNC configuration files are properly set up..."
touch /root/.Xauthority
chmod 600 /root/.Xauthority

mkdir -p /root/.vnc
echo -e "$VNC_PASSWORD\n$VNC_PASSWORD\n" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd
echo "VNC password file created and permissions secured."

if [ -z "$P2P_EMAIL" ]; then
  echo "P2P_EMAIL is not set or is blank. Skipping creation of the Peer2Profit configuration file."
else
  FLAG_FILE="/home/root/.config/org.peer2profit.setup_done"

  if [ -f "$FLAG_FILE" ]; then
    echo "Peer2Profit configuration file has already been created. Skipping."
  else
    INSTALL_ID2=$(uuidgen)
    CONFIG_FILE="/home/root/.config/org.peer2profit.peer2profit.ini"
    CONFIG_DIR=$(dirname "$CONFIG_FILE")
    mkdir -p "$CONFIG_DIR"
    cat <<EOF > "$CONFIG_FILE"
[General]
Username=$P2P_EMAIL
hideToTrayMsg=true
installid2=$INSTALL_ID2
locale=en_US
EOF

    chown -R "root:root" "$CONFIG_DIR"

    # Create the flag file to mark the script as completed
    touch "$FLAG_FILE"
    echo "Peer2Profit configuration file created successfully at $CONFIG_FILE."
  fi
fi

cat << EOF > /root/.vnc/xstartup
#!/bin/sh
xrdb \$HOME/.Xresources
startxfce4 &
EOF

chmod +x /root/.vnc/xstartup
echo "VNC xstartup script created and made executable."

echo "Starting SSH service..."
service ssh restart

echo "Stopping any existing VNC server processes..."
pkill -f "Xvnc" || echo "No existing VNC processes found."

echo "Starting VNC server on display :1 with geometry $VNC_RESOLUTION and 24-bit depth..."
vncserver :1 -geometry "$VNC_RESOLUTION" -depth 24

echo "Starting noVNC on port 6080..."
/opt/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen 6080 &

echo "Initialization complete. Container is now ready."
tail -f /dev/null
