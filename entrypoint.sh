#! /bin/sh
# VARIABLES

export WINEARCH=win64
export WINEPREFIX=/wineprefix
export DISPLAY=":99"
export PWD=/app/torch-server/
echo "----------------------------- INIT SERVER ---------------------------"

if [ ! -f /app/.Xauthority ]; then
  touch /app/x11vnc.log /app/.Xauthority
fi
bash -c 'Xvfb :99 -screen 0 1024x768x24 -ac -br -nolisten unix &'
bash -c 'x11vnc -display WAIT:99 -forever -autoport 5900 -auth /app/.Xauthority -passwd $VNCPASSWORD -o /app/x11vnc.log -bg &'

echo "Waiting 5 seconds for X server to initialize..."
echo "Entrypoint injected."
sleep 5

bash -c 'DISPLAY=:99 openbox &'
echo "Openbox started."

# Open up file browser
#bash -c 'DISPLAY=":99" winefile &'
#echo "Winefile started in VNC WM"

# Run Torch Server
echo "Starting Torch Server ..."
bash -c 'DISPLAY=":99" wine $WINEPARAMS Z:/app/torch-server/Torch.Server.exe $TORCHFLAGS '
#xvfb-run -n 99 -l -f /app/.Xauthority -- wine torch-server/Torch.Server.exe $@ &

echo "Something didn't work.  Break this."
