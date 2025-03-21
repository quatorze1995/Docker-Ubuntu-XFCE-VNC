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

cat << EOF > /root/.vnc/xstartup
#!/bin/sh
xrdb \$HOME/.Xresources
startxfce4 &
EOF
chmod +x /root/.vnc/xstartup
echo "VNC xstartup script created and made executable."

echo "Stopping any existing VNC server processes..."
pkill -f "Xvnc" || echo "No existing VNC processes found."

echo "Starting VNC server on display :1 with geometry $VNC_RESOLUTION and 24-bit depth..."
vncserver :1 -geometry "$VNC_RESOLUTION" -depth 24

echo "Initialization complete. Container is now ready."
tail -f /dev/null
