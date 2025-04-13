FROM debian:sid-slim

WORKDIR /root

# ARG only available during build
# never env DEBIAN_FRONTEND=noninteractive !!
ARG DEBIAN_FRONTEND=noninteractive
ARG WINEBRANCH=staging
ENV WINEARCH=win64
ENV WINEDEBUG=-all
ENV WINEPREFIX=/wineprefix
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1


RUN dpkg --add-architecture i386 && \
  sed -i -e 's/main/main contrib/g'  /etc/apt/sources.list.d/debian.sources && \
  apt update && apt -y upgrade

RUN \
  apt install -y --no-install-recommends \
  wget unzip xvfb x11vnc novnc openbox menu

RUN \
  apt install -y \
  winetricks wine

COPY ./scripts/winetricks.sh /root


RUN \
  chmod +x /root/winetricks.sh && \
  bash -c 'WINEARCH=win64 WINEPREFIX=/wineprefix /root/winetricks.sh' && \
  rm -rf /root/* && \
  unset DISPLAY && \
  winecfg

# Set final packages and package manager state.
RUN \
  apt install -y procps unzip wget && \
  apt autopurge -y && \
  apt -qq clean autoclean && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/
  
COPY ./scripts/entrypoint.sh /root/
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT /root/entrypoint.sh
