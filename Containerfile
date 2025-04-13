FROM debian:sid-slim

WORKDIR /root

# ARG only available during build
# never env DEBIAN_FRONTEND=noninteractive !!
ARG DEBIAN_FRONTEND=noninteractive
ARG WINEBRANCH=staging
ARG WINEVERSION=
#"=10.2~bookworm-4"
ENV WINEARCH=win64
ENV WINEDEBUG=-all
ENV WINEPREFIX=/wineprefix
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

RUN \
  sed -i -e 's/main/main contrib/g'  /etc/apt/sources.list.d/debian.sources && \
  dpkg --add-architecture i386 && \
  apt update && apt -y upgrade

RUN \
  apt install -y \
  wget unzip winetricks wine xvfb x11vnc novnc openbox menu
#RUN \
#  dpkg --add-architecture i386 && \
#  apt-get -qq -y update && \
#  apt-get upgrade -y -qq && \
#  apt-get install -y -qq software-properties-common curl perl gnupg2 wget unzip && \
  # add repository keys
#  mkdir -pm755 /etc/apt/keyrings && \
#  wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
#  wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources && \
#  apt-get update && \
#  apt-get install -y --no-install-recommends xvfb x11vnc openbox menu && \
#  apt-get install -qq -y --no-install-recommends \
#  winehq-${WINEBRANCH} \
#  wine-${WINEBRANCH}-i386 \
#  wine-${WINEBRANCH}-amd64 \
#  wine-${WINEBRANCH} && \
#  wine \
#  steamcmd ]
#  curl -L https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks > /usr/local/bin/winetricks && \
#  chmod +x /usr/local/bin/winetricks && \ 
#  mkdir /scripts /wineprefix /app

COPY ./scripts/winetricks.sh /root


RUN \
  chmod +x /root/winetricks.sh && \
  bash -c 'WINEARCH=win64 WINEPREFIX=/wineprefix /root/winetricks.sh' && \
  rm -rf /root/* && \
  unset DISPLAY && \
  winecfg

# Remove stuff we do not need anymore to reduce docker size
RUN \
  apt install -y psmisc unzip wget sudo && \
  apt autopurge -y && \
  apt -qq clean autoclean && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/
  
COPY ./scripts/entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT /root/entrypoint.sh
