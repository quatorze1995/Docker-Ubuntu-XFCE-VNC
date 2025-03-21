#!/bin/bash

# Enable debug mode for detailed output (optional)
set -x

echo "Starting container initialization..." | tee -a /var/log/container.log

# Default password for root
VNC_PASSWORD=${VNC_PASSWORD:-"password"}
export USER=root

echo "Password (truncated to 8 characters): $VNC_PASSWORD" | tee -a /var/log/container.log

# Default resolution
VNC_RESOLUTION=${RESOLUTION:-"1600x900"}

# Ensure .Xauthority and .Xresources are set for root
if [ ! -f /root/.Xresources ]; then
    echo "*customization: -color" > /root/.Xresources
    echo "Created default /root/.Xresources" | tee -a /var/log/container.log
fi

touch /root/.Xauthority
chmod 600 /root/.Xauthority
echo "Created .Xauthority for root at /root/.Xauthority" | tee -a /var/log/container.log

# Update VNC password for root
mkdir -p /root/.vnc
echo -e "$VNC_PASSWORD\n$VNC_PASSWORD\n" | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd
echo "VNC password updated and saved in /root/.vnc/passwd" | tee -a /var/log/container.log

# Create xstartup for root
cat << EOF > /root/.vnc/xstartup
#!/bin/sh
xrdb $HOME/.Xresources
startxfce4 &
EOF
chmod +x /root/.vnc/xstartup
echo "Configured xstartup file for root at /root/.vnc/xstartup" | tee -a /var/log/container.log

# Cleanup any existing VNC/X server processes
pkill -f "Xvnc" || true

# Start VNC server with a specific display and resolution
echo "Starting the VNC server on display :1 with resolution $VNC_RESOLUTION..." | tee -a /var/log/container.log
vncserver :1 -geometry "$VNC_RESOLUTION" -depth 24 >> /var/log/container.log 2>&1

echo "Initialization complete. VNC server running." | tee -a /var/log/container.log

# Keep the container running
tail -f /var/log/container.log
