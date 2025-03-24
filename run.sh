docker run -d -p 5901:5901 -p 6080:6080 -p 22222:22222 \
  -e VNC_PASSWORD=password \
  -e VNC_RESOLUTION=1600x900 \
  ubuntu-xfce-vnc
