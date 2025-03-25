# Use Ubuntu 24 as the base image
FROM ubuntu:24.04

# Set environment variable to suppress interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Preconfigure keyboard layout to English (US)
RUN echo 'keyboard-configuration keyboard-configuration/layoutcode select us' | debconf-set-selections

# Install packages
RUN apt-get update -y && apt-get install -y \
    xfce4 xfce4-appfinder xfce4-appmenu-plugin xfce4-battery-plugin xfce4-clipman xfce4-clipman-plugin xfce4-cpufreq-plugin xfce4-cpugraph-plugin xfce4-datetime-plugin xfce4-dev-tools xfce4-dict xfce4-diskperf-plugin xfce4-eyes-plugin xfce4-fsguard-plugin xfce4-genmon-plugin xfce4-goodies xfce4-helpers xfce4-indicator-plugin xfce4-mailwatch-plugin xfce4-mount-plugin xfce4-mpc-plugin xfce4-netload-plugin xfce4-notes xfce4-notes-plugin xfce4-notifyd xfce4-panel xfce4-panel-profiles xfce4-places-plugin xfce4-power-manager xfce4-power-manager-data xfce4-power-manager-plugins xfce4-pulseaudio-plugin xfce4-screensaver xfce4-screenshooter xfce4-sensors-plugin xfce4-session xfce4-settings xfce4-smartbookmark-plugin xfce4-sntray-plugin xfce4-sntray-plugin-common xfce4-systemload-plugin xfce4-taskmanager xfce4-terminal xfce4-time-out-plugin xfce4-timer-plugin xfce4-verve-plugin xfce4-wavelan-plugin xfce4-weather-plugin xfce4-whiskermenu-plugin xfce4-windowck-plugin xfce4-xkb-plugin \
    tightvncserver xfonts-base xfonts-75dpi xfonts-100dpi dbus-x11 \
    sudo util-linux iproute2 net-tools git curl wget nano gdebi gnupg dialog htop util-linux uuid-runtime seahorse openssh-server

RUN apt-get install -y \
    ca-certificates fonts-liberation xdg-utils \
    libappindicator3-1 libasound2t64 libatk1.0-0 libatk-bridge2.0-0 libatspi2.0-0 libayatana-common0 libayatana-indicator3-7 \
    libbsd0 \
    libc6 libcairo2 libcups2 libcurl4 \
    libdbus-1-3 \
    libexpat1 \
    libgbm1 libgl1 libglib2.0-0 libgtk-3-0 libgtk-3-0t64 libgtk-3-bin libgtk-3-bin libgtk-3-common libgtk-4-1 libgtk-4-1 libgtk-4-bin libgtk-4-common \
    libnotify4 libnotify-bin libnspr4 libnss3 \
    libpango-1.0-0 \
    libudev1 libuuid1 \
    libvulkan1 \
    libwebkit2gtk-4.1-0 libwebkitgtk-6.0-4 \
    libx11-6 libx11-xcb1 libxau6 libxcb1 libxcb-glx0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render0 libxcb-render-util0 libxcb-shape0 libxcb-shm0 libxcb-sync1 libxcb-util1 libxcb-xfixes0 libxcb-xinerama0 libxcb-xkb1 libxcomposite1 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxkbcommon0 libxkbcommon-x11-0 libxrandr2

# Download and install the Google Chrome from the official source
RUN wget -O /tmp/google-chrome-stable.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    gdebi --n /tmp/google-chrome-stable.deb && \
    rm /tmp/google-chrome-stable.deb

# Download and install the Wipter application from the official source
RUN wget -O /tmp/wipter.deb https://provider-assets.wipter.com/latest/linux/x64/wipter-app-amd64.deb && \
    gdebi --n /tmp/wipter.deb && \
    rm /tmp/wipter.deb

# Download and install the Peer2Profit application from the official source
RUN wget -O /tmp/peer2profit.deb https://updates.peer2profit.app/peer2profit_0.48_amd64.deb && \
    gdebi --n /tmp/peer2profit.deb && \
    rm /tmp/peer2profit.deb

# Download and install the UpRock Mining application from the official source
RUN wget -O /tmp/UpRock-Mining.deb https://edge.uprock.com/v1/app-download/UpRock-Mining-v0.0.8.deb && \
    gdebi --n /tmp/UpRock-Mining.deb && \
    rm /tmp/UpRock-Mining.deb

# Block similar named Grass App and Install the Grass application from the official source
RUN apt-mark hold \
    grass-core grass-dev-doc grass-dev grass-doc grass-gui grass

RUN wget -O /tmp/Grass.deb https://files.getgrass.io/file/grass-extension-upgrades/ubuntu-22.04/Grass_5.2.2_amd64.deb && \
    gdebi --n /tmp/Grass.deb && \
    rm /tmp/Grass.deb

# Clone noVNC for browser-based VNC access
RUN git clone https://github.com/novnc/noVNC /opt/noVNC && \
    chmod +x /opt/noVNC/utils/novnc_proxy && \
    cp /opt/noVNC/vnc.html /opt/noVNC/index.html
RUN git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify

# Set up X resources for customization
RUN echo "*customization: -color" > /root/.Xresources

# Set up TightVNC configuration
RUN mkdir -p /root/.vnc

# Create .Xauthority for root and ensure correct permissions
RUN touch /root/.Xauthority && chmod 600 /root/.Xauthority

# Move OpenSSH Server to 22222
RUN sed -i 's/#Port 22/Port 22222/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "ListenAddress 0.0.0.0" >> /etc/ssh/sshd_config && \
    echo "ListenAddress ::" >> /etc/ssh/sshd_config && \
    mkdir -p /var/run/sshd

# Create a shortcut for Google Chrome on the Desktop
RUN mkdir -p /root/Desktop && \
    cat <<EOF > /root/Desktop/google-chrome.desktop
[Desktop Entry]
Version=1.0
Name=Google Chrome
Comment=Access the Internet
Exec=/usr/bin/google-chrome-stable --no-sandbox --window-size=1600,900 %U
Icon=google-chrome
Terminal=false
Type=Application
Categories=Network;WebBrowser;
EOF
RUN chmod +x /root/Desktop/google-chrome.desktop

# Clean up unnecessary packages and cache to reduce image size
RUN apt-get autoclean && apt-get autoremove -y && apt-get autopurge -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose the VNC port
EXPOSE 5901 6080 22222

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the default command
CMD ["/usr/local/bin/entrypoint.sh"]
