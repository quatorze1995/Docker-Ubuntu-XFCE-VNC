#!/bin/bash
echo " "
echo "Starting container initialization..."

echo " "
echo "Setting up VNC with Resolution: $VNC_RESOLUTION and Password: $VNC_PASSWORD..."
VNC_RESOLUTION=${RESOLUTION:-"4800x900"}
VNC_PASSWORD=${VNC_PASSWORD:-"password"}
export USER=root

if [ ! -f /root/.Xresources ]; then
	echo " "
    echo "Creating a default '/root/.Xresources' with basic customization..."
    echo "*customization: -color" > /root/.Xresources
else
	echo " "
    echo "Found existing '/root/.Xresources'. No changes made."
fi

echo " "
echo "Ensuring VNC configuration files are properly set up..."
touch /root/.Xauthority
chmod 600 /root/.Xauthority

mkdir -p /root/.vnc
echo -e "$VNC_PASSWORD\n$VNC_PASSWORD\n" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd
echo " "
echo "VNC password file created and permissions secured."

if [ -z "$P2P_EMAIL" ]; then
  echo " "
  echo "P2P_EMAIL is not set or is blank. Skipping creation of the Peer2Profit configuration file."
else
  FLAG_FILE="/root/.config/org.peer2profit.setup_done"

  if [ -f "$FLAG_FILE" ]; then
    echo " "
    echo "Peer2Profit configuration file has already been created. Skipping."
  else
    INSTALL_ID2=$(uuidgen)
    CONFIG_FILE="/root/.config/org.peer2profit.peer2profit.ini"
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
	echo " "
    echo "Peer2Profit configuration file created successfully at $CONFIG_FILE."
  fi
fi

cat << EOF > /root/.vnc/xstartup
#!/bin/sh
xrdb \$HOME/.Xresources
startxfce4 &
EOF

chmod +x /root/.vnc/xstartup
echo " "
echo "VNC xstartup script created and made executable."

echo " "
echo "Starting SSH service..."
service ssh restart

echo " "
echo "Stopping any existing VNC server processes..."
pkill -f "Xvnc" || echo "No existing VNC processes found."

echo "Stopping any existing VNC server processes..."
pkill -f "Xvnc" || echo "No existing VNC processes found."

echo " "
echo "Checking for and removing stale VNC lock and temporary files..."
if [ -f /tmp/.X1-lock ]; then
    echo " "
    echo "Found stale /tmp/.X1-lock file. Removing it..."
    rm -f /tmp/.X1-lock
fi
if [ -d /tmp/.X11-unix ]; then
    echo " "
    echo "Removing stale /tmp/.X11-unix directory..."
    rm -rf /tmp/.X11-unix
fi

echo " "
echo "Starting VNC server on display :1 with geometry $VNC_RESOLUTION and 24-bit depth..."
vncserver :1 -geometry "$VNC_RESOLUTION" -depth 24

echo " "
echo "Starting noVNC on port 6080..."
/opt/noVNC/utils/novnc_proxy --vnc localhost:5901 --listen 6080 &

echo " "
echo "Initialization complete. Container is now ready."
tail -f /dev/null
