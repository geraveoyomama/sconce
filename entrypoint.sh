#! /bin/sh
# VARIABLES

export WINEARCH=win64
export WINEPREFIX=/wineprefix
export DISPLAY=":99"
export PWD=/app/torch-server
export VNCPASSWORD
cd /app/torch-server
if [ ! -f ./torch-server.zip ]; then
  wget https://build.torchapi.com/job/Torch/job/master/lastSuccessfulBuild/artifact/bin/torch-server.zip && unzip -u torch-server.zip
fi

#if [ ! -f ./Torch.Server.exe ]; then
#  unzip -u torch-server.zip 
#fi

echo "----------------------------- INIT SERVER ---------------------------"

if [ ! -f /app/.Xauthority ]; then
  touch /app/x11vnc.log /app/.Xauthority
fi

bash -c 'Xvfb :99 -screen 0 1024x768x24 -ac -br -nolisten unix &'


if [ "$VNCPASSWORD" ]; then
  bash -c 'x11vnc -display WAIT:99 -forever -autoport 5900 -auth /app/.Xauthority -passwd $VNCPASSWORD -o /app/x11vnc.log -bg &'
  echo "VNC password set."
else
  bash -c 'x11vnc -display WAIT:99 -forever -autoport 5900 -auth /app/.Xauthority -o /app/x11vnc.log -bg &'
  echo "No VNC password set."
fi


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

#echo "Something didn't work.  Break this."
echo "Reloading entrypoint."

#killall "Z:/app/torch-server/Torch.Server.exe" &
wineserver -k &
killall openbox &
killall x11vnc &
killall Xvfb &
sleep 5
