# Dockerized Xfce Desktop with TightVNC on Ubuntu 24.04
#### This Docker image provides a lightweight, containerized Xfce desktop environment, pre-configured and accessible through TightVNC. Built on Ubuntu 24.04, it allows seamless access to a remote desktop for graphical application support and system management.

## Features
 - **Base OS** : Ubuntu 24.04 for a reliable foundation.
 - **Desktop Environment** : Xfce4 for a lightweight and user-friendly interface.
 - **VNC Server** : TightVNC for secure remote desktop access.
 - **Customizable Settings** :
   - **Resolution** : Easily adjustable VNC geometry (default: 1600x900).
   - **Ports** :  Default 5901 TightVNC server port.
   - Password-protected access for secure sessions.
   - Includes essential fonts and utilities for enhanced graphical application compatibility.
 - **Environment Variables** :
   - **```VNC_PASSWORD```** : Sets the root password for VNC access (default: **```password```** ).
   - **```VNC_RESOLUTION```** : Adjusts the screen resolution for the VNC server (default: **```1600x900```** ).

## File Structure
```
.
├── Dockerfile          # Builds the Ubuntu-based image.
├── entrypoint.sh       # Handles initialization, such as password setup, resolution settings, and starting the VNC server.
├── run.sh              # Simplified script for running the Docker container.
└── README.md           # Script to build the Docker image.
```

