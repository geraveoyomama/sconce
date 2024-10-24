Welcome to Sconce!

This repo is built for older versions of podman. Specifically the version available in debian bookworm. This repo will be updated to match up to date versions of podman once trixie is hailed into stable.

Tested to work with SE 1.205.

***IF YOU RUN INTO ERRORS, SUBMIT AN ISSUE HERE FIRST AND THEN IF IT'S UNRESOLVED GO TO TORCH FOR HELP THEN KEEN FOR HELP***

## podman TorchAPI Server in Debian-slim with Wine 9
---

This is a container image you can build yourself from Debian-slim. It will launch Space Engineers Torch Server, and you can interact with it through a password protectedVNC server.

This was created by combining previous work done by very smart people.

### Features
---
 - Wine 9 (staging, esync compatible)
 - Configurable parameters for the container (torch autostart, password config).
 - Torch GUI over VNC (password configurable).
 - No permission issues. The container has the same access as the running user. DO NOT RUN AS ROOT. Make specifici user if you need to and rely on standard linux permissions.
 - remote API works

## Requirements
---
- podman
- podman-compose
- unzip
- wget
- Any VNC viewer

## Configuration
---
All configuration is done in the podman-compose.yml file. 

### Notable options:
- VNCPASSWORD=mypassword #handles the password for the VNC server #must be set
- WINEESYNC=1 #comment to disable ESYNC
- WINEPARAMS= #additional parameters passed AFTER wine command (wine $WINEPARAMS %command%)
- TORCHFLAGS=-autostart #torch flags for autostart or specific instance paths.

## Usage
---
1. either have or add a non sudo user to run sconce
2. su to the user
3. Clone this repo (`git clone https://github.com/geraveoyomama/sconce`)
4. change directory to sconce (`cd sconce`)
5. Run `./start`

First run will build the docker on your system, please be patient.

You can Ctrl-C break out of the start script after Torch is loaded, and it will
continue running in the background. You can access the VNC server as
well. It will place the server and instances into /torch-server/xxxxx.
You can configure the server and instance after first run, but ideally ./stop
it first.

To connect through VNC, point your client at `$HOST:5900` and it
should prompt you for your password.

As well as the torch server, there is also a file manager instance
that is launched alongside it, for your use to manage files.

3. Run `./stop`

This will kill and unload all docker processes.  You shouldn't configure the server files from outside the Docker unless you have made sure all processes are stopped and unloaded from memory.



## Notes
---
- This is designed for headless servers, nonetheless it will work on headed servers.
- The window manager does not like it when the programs are closed.  If you close the server for any reason, you have to restart the docker.  Restarting the server actually closes it, and breaks the window manager (but it still restarts).  Also, you can only edit the server configs before you start it, not after.  I will try to fix this.
- Enter the container by running: `podman exec -it sconce /bin/bash`
- This If you need to update or change the start/stop scripts, you need to rebuild the docker image with the docker-compose up command including a --build flag. Once this has been done I request you make a merge request to add the functionality to the master sconce repo.
- to access the remote API add `<RemoteApiIP>your.IP.in.here</RemoteApiIP>` to your `spaceengineers-dedicated.cfg`, the port is 8080.
- If the remote API port is already in use change the external 8080 port to an available port.

## Credits & Acknowledgements
---
- [iamtakingiteasy](https://github.com/iamtakingiteasy/se-torchapi-ds-docker)
- [mmmaxwwwell](https://github.com/mmmaxwwwell)
- [jeppevinkel](https://github.com/jeppevinkel)
- [soyasoya5](github.com/soyasoya5/se-torchapi-linux)
- [Devidian](https://github.com/Devidian/docker-spaceengineers)
- [stubkan](https://github.com/stubkan/torchapi-wine9)
