FROM debian:bookworm-slim

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
  dpkg --add-architecture i386 && \
  apt-get -qq -y update && \
  apt-get upgrade -y -qq && \
  apt-get install -y -qq software-properties-common curl perl gnupg2 wget unzip && \
  # add repository keys
  mkdir -pm755 /etc/apt/keyrings && \
  wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
  wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources && \
  apt-get update && \
  apt-get install -y --no-install-recommends xvfb x11vnc novnc openbox menu && \
  apt-get install -qq -y --no-install-recommends \
  winehq-${WINEBRANCH} \
  wine-${WINEBRANCH}-i386 \
  wine-${WINEBRANCH}-amd64 \
  wine-${WINEBRANCH} && \
#  wine \
#  steamcmd ]
  curl -L https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks > /usr/local/bin/winetricks && \
  chmod +x /usr/local/bin/winetricks && \ 
  mkdir /scripts /wineprefix /app

COPY ./scripts/winetricks.sh /scripts


RUN \
  chmod +x /scripts/winetricks.sh && \
  bash -c 'WINEARCH=win64 WINEPREFIX=/wineprefix /scripts/winetricks.sh' && \
  rm -rf /scripts && \
  rm /usr/local/bin/winetricks && \
  unset DISPLAY && \
  winecfg

# Remove stuff we do not need anymore to reduce docker size
RUN \
  apt-get purge -qq -y software-properties-common curl gnupg2 && \
  apt-get autopurge -qq -y perl && \
  apt-get -qq clean autoclean && \
  apt install -y psmisc unzip wget && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/
  
COPY ./scripts/entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT /root/entrypoint.sh
