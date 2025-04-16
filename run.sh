docker run -d -p 5901:5901 -p 5902:5902 -p 5903:5903 -p 6080:6080 -p 22222:22222 \
  -e VNC_PASSWORD=password \
  -e VNC_RESOLUTION=1600x900 \
  -e P2P_EMAIL=email@example.com \
  -v /etc/_docker/ubuntu-xfce-vnc:/root/.local/share
  ubuntu-xfce-vnc
