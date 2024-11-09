FROM debian:bookworm-slim

WORKDIR /root

# ARG only available during build
# never env DEBIAN_FRONTEND=noninteractive !!
ARG DEBIAN_FRONTEND=noninteractive
ARG WINEBRANCH=staging
ARG WINEVERSION=9.20~bookworm-1

ENV WINEARCH=win64
ENV WINEDEBUG=-all
ENV WINEPREFIX=/wineprefix
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

RUN \
  dpkg --add-architecture i386 && \
  apt-get -qq -y update && \
  apt-get upgrade -y -qq && \
  apt-get install -y -qq software-properties-common curl perl gnupg2 wget unzip && \
  # add repository keys
  mkdir -pm755 /etc/apt/keyrings && \
  wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
  # add repositories
#  echo "deb http://ftp.us.debian.org/debian bookworm main non-free" > /etc/apt/sources.list.d/non-free.list && \
  wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources && \
  apt-get update && \
  apt-get install -y --no-install-recommends x11vnc openbox menu && \
# libfaudio0 libfaudio0:i386
#RUN \
#  apt-get update -qq && \
#  echo steam steam/question select "I AGREE" | debconf-set-selections && \
#  echo steam steam/license note '' | debconf-set-selections && \
#  apt-get install -qq -y \
#  libfaudio0:i386 \
#  libfaudio0 

#RUN \ 
  apt-get install -qq -y --no-install-recommends \
  winehq-${WINEBRANCH}=${WINEVERSION} \
  wine-${WINEBRANCH}-i386=${WINEVERSION} \
  wine-${WINEBRANCH}-amd64=${WINEVERSION} \
  wine-${WINEBRANCH}=${WINEVERSION} \
#  wine \
#  steamcmd ]
  xvfb \
  cabextract && \
  curl -L https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks > /usr/local/bin/winetricks && \
  chmod +x /usr/local/bin/winetricks && \ 
  mkdir /scripts /wineprefix /app

COPY ./winetricks.sh /scripts


RUN \
  chmod +x /scripts/winetricks.sh && \
  bash -c 'WINEARCH=win64 WINEPREFIX=/wineprefix /scripts/winetricks.sh' && \
  rm -rf /scripts && \
  rm /usr/local/bin/winetricks && \

#RUN \
#  apt-get autopurge -qq -y  \
#  winehq-${WINEBRANCH}=${WINEVERSION} \
#  wine-${WINEBRANCH}-i386=${WINEVERSION} \
#  wine-${WINEBRANCH}-amd64=${WINEVERSION} \
#  wine-${WINEBRANCH}=${WINEVERSION} \
#  wine

#ARG WINEBRANCH=staging
#ARG WINEVERSION=9.20~bookworm-1

#RUN \
#  apt-get install -qq -y --install-recommends \
#  winehq-${WINEBRANCH}=${WINEVERSION} \
#  wine-${WINEBRANCH}-i386=${WINEVERSION} \
#  wine-${WINEBRANCH}-amd64=${WINEVERSION} \
#  wine-${WINEBRANCH}=${WINEVERSION}

#RUN \
  unset DISPLAY && \
  winecfg

# Remove stuff we do not need anymore to reduce docker size
RUN \
  apt-get purge -qq -y software-properties-common curl gnupg2 && \
  apt-get autopurge -qq -y perl && \
  apt-get -qq clean autoclean && \
  apt install -y psmisc unzip wget && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/
  
COPY entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT /root/entrypoint.sh
