Welcome to Sconce!

This repos contents are designed to work in an automated environment of updates, reboots and recovery. It is not designed for babysitting.

This repo is currently in transition from debian 12 to debian 13 as its running environment. In the container its still deb12

Tested to work with SE 1.205+.

***IF YOU RUN INTO ERRORS, SUBMIT AN ISSUE HERE FIRST AND THEN IF IT'S UNRESOLVED GO TO TORCH FOR HELP THEN KEEN FOR HELP***

## podman TorchAPI Server in Debian-slim with Wine 9
---

This is a container image to run Torch for space engineers. You can interact with it through a password protected VNC server or by editing the configs manually.

This was created by combining previous work done by very smart people, credits down below.

### Features
---
 - Wine 9 (staging, esync enabled by default)
 - Configurable parameters for the container (torch autostart, password config).
 - Torch GUI over VNC (password configurable, empty for no password).
 - No permission issues. The container has the same access as the running user. DO NOT RUN AS ROOT. Create specific user to isolate and rely on standard linux file permissions.
 - remote API working

## Requirements
---
- podman
- podman-compose
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
3. Get the yaml (`wget https://raw.githubusercontent.com/geraveoyomama/sconce/refs/heads/main/podman-compose.yml`)
4. Configure the yaml (`nano podman-compose.yml`)
5. Run `podman compose up -d`


#### Alternatively clone the entire repo with `git clone https://github.com/geraveoyomama/sconce` and run `./start`

ONLY CONFIGURE THE SERVER WHEN IT IS NOT RUNNING IF NOT DOING IT THROUGH THE GUI!

You can access the VNC server as well. It will place the server and instances into /torch-server/xxxxx.
You can configure the server and instance after first run.

To connect through VNC, point your client at `$HOST:5900` and it
should prompt you for your password.



## Notes
---
- This is designed for headless servers, nonetheless it will work on headed servers.
- Closing the Torch window restarts all processes in the container. The container does not need to reboot to apply changes to torch.
- Enter the container by running: `podman exec -it sconce /bin/bash`
- If you want to change the entrypoint script, you need to rebuild the image. Once this has been done I request you make a merge request to add the functionality to the master sconce repo.
- To access the remote API add `<RemoteApiIP>your.IP.in.here</RemoteApiIP>` to your `spaceengineers-dedicated.cfg`, the port is 8080.
- If the remote API port is already in use change the external 8080 port to an available port.

## Credits & Acknowledgements
---
- [iamtakingiteasy](https://github.com/iamtakingiteasy/se-torchapi-ds-docker)
- [mmmaxwwwell](https://github.com/mmmaxwwwell)
- [jeppevinkel](https://github.com/jeppevinkel)
- [soyasoya5](github.com/soyasoya5/se-torchapi-linux)
- [Devidian](https://github.com/Devidian/docker-spaceengineers)
- [stubkan](https://github.com/stubkan/torchapi-wine9)
