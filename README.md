Welcome to Sconce!

## podman TorchAPI Server in Debian-slim with Wine 9
---

This is a container image you can build yourself from Debian-slim.
It will launch Space Engineers Torch Server, and you can interact with it
through a passworded VNC server, or through Command Line Interface
(CLI).

This was created by combining previous work done by very smart people.

This version combines soyasoya5's TorchAPI on Linux Docker and
Devidian's work on streamlining and updating the old Dockers.

### Features
---
 - Wine 9 (staging, esync compatible)
 - Configurable parameters for the container (torch autostart, password config).
 - Torch GUI over VNC (password configurable).
 - No permission issues. They are directly passed through to the container.

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
- VNCPASSWORD= #handles the password for the VNC server
- WINEESYNC=1 #comment to disable ESYNC
- WINEPARAMS= #additional parameters passed AFTER wine command (wine $WINEPARAMS %command%)
- TORCHFLAGS=-autostart #torch flags for autostart or specific instance paths.

## Usage
---
1. Clone this repo
2. Run `./start`

First run will build the docker on your system, please be patient.
After it is complete, you should see this;

![TorchAPI from Command Line](images/torchapi-start.png)

You can Ctrl-C break out of the start script after it's loaded Torch, and it will
continue running in the background.  You can access the VNC server as
well.  It will place the server and instances into /torch-server/xxxxx.
You can configure the server and instance after first run, but ideally ./stop
it first.

To connect through VNC, point your client at `your.server.ip.address:5900` and it
should prompt you for your password.

As well as the torch server, there is also a file manager instance
that is launched alongside it, for your use to manage files.

3. Run `./stop`

This will kill and unload all docker processes.  You shouldn't configure the server files from outside the Docker unless you have made sure all processes are stopped and unloaded from memory.

The user that runs Torch/Space Engineers is wine:wine and not root or whatever your user is.  This means you may end up with conflicting owners when you paste in files into the Instance (or another folder), and may end up with a situation like below ;

![Files not Owned](images/torchapi-owner.png)

You can see that the Dedicated cfg file and Storage is owned by root and not wine.  When Torch runs under wine, it will be unable to edit those because its not the owner.  You can fix this by using the chown recursive command to change the ownership of a directory and all its subdirectories and files;

`chown -R wine:wine .`

## Notes
---
- As the Torch-API download site appears to be down at the moment, I
have hosted the most recent Torch Server zip file on this repository.
So, this docker will work without requiring downloading of Torch at
the moment.
- This works on headless servers, as you can interface it through SSH
alone.
- The window manager does not like it when the programs are closed.  If you close the server for any reason, you have to restart the docker.  Restarting the server actually closes it, and breaks the window manager (but it still restarts).  Also, you can only edit the server configs before you start it, not after.  I will try to fix this.
- Attach a terminal session into the Dockers Debian space by running this command: `docker exec -it torchapi /bin/bash`
- If you need to update or change the start/stop scripts, you need to rebuild the docker image with the docker-compose up command including a --build flag.

## Credits & Acknowledgements
---
- [iamtakingiteasy](https://github.com/iamtakingiteasy/se-torchapi-ds-docker)
- [mmmaxwwwell](https://github.com/mmmaxwwwell)
- [jeppevinkel](https://github.com/jeppevinkel)
- [soyasoya5](github.com/soyasoya5/se-torchapi-linux)
- [Devidian](https://github.com/Devidian/docker-spaceengineers)
