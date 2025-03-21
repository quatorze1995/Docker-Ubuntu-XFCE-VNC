# Dockerized Xfce Desktop with TightVNC on Ubuntu 24.04

This Docker image provides a pre-configured Xfce desktop environment accessible through TightVNC. It is built on Ubuntu 24.04 and can be used to run a remote desktop on a containerized lightweight Linux GUI.

---

## Features
- **Base OS**: Ubuntu 24.04
- **Desktop Environment**: Xfce4
- **VNC Server**: TightVNC
- Includes essential fonts and utilities for graphical application support.
- Password-protected VNC access for secure sessions.
- Customizable VNC geometry (default: 1600x900 resolution).
  
---

## Ports Exposed
- **5900**: VNC server port.

---

## Environment Variables
- `VNC_PASSWORD`: Sets the VNC server's root password (default: "password").

---

## Usage

### 1. **Build the Docker Image**
```bash
docker build -t xfce-vnc .
