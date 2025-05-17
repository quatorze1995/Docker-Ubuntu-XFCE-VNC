docker run -d -p 5901:5901 -p 6080:6080 \
  -e VNC_PASSWORD=password \
  -e VNC_RESOLUTION=1024x768 \
  -e P2P_EMAIL=email@example.com \
  -e WIPTER_EMAIL=email@example.com \
  -e WIPTER_PASSWORD=password \
  -v /etc/_docker/ubuntu-xfce-vnc:/root/.local/share \
  ubuntu-xfce-vnc
