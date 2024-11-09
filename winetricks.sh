#! /bin/bash

env WINEDEBUG=-all WINEDLLOVERRIDES="mscoree=d" wineboot --init /nogui 
env WINEDEBUG=-all winetricks --force win10 
env WINEDEBUG=-all winetricks corefonts 
env DISPLAY=:99.0 WINEDEBUG=-all winetricks sound=disabled 
env DISPLAY=:99.0 WINEDEBUG=-all winetricks -q vcrun2013 
env DISPLAY=:99.0 WINEDEBUG=-all winetricks -q vcrun2017 
env DISPLAY=:99.0 WINEDEBUG=-all winetricks -q vcrun2019
env DISPLAY=:99.0 WINEDEBUG=-all winetricks -q --force dotnet48 
env DISPLAY=:99.0 WINEDEBUG=-all winetricks sound=disabled 
env DISPLAY=:99.0 WINEDEBUG=-all winetricks -q d3dcompiler_47
env DISPLAY=:99.0 WINEDEBUG=-all wine reg add 'HKCU\Software\Wine\DllOverrides' '/f' '/v' 'd3d9' '/t' 'REG_SZ' '/d' 'native'
env DISPLAY=:99.0 WINEDEBUG=-all wine reg add "HKCU\\SOFTWARE\\Microsoft\\Avalon.Graphics" /v DisableHWAcceleration /t REG_DWORD /d 1 /f
env WINEDEBUG=-all winetricks --force win10
rm -rf  ~/.cache ~/.config ~/.local /tmp/*
