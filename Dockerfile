FROM ghcr.io/skillable-public/docker-desktop-debian:latest

ARG HOME=/home/user
ARG DEBIAN_FRONTEND="noninteractive"

RUN \
  apt update && apt upgrade -y && \
  apt install -y \
    apache2 \
    mariadb-server \
    php libapache2-mod-php php-mysql && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*  

RUN \
  ARCH=$(arch | sed 's/aarch64/arm64/g' | sed 's/x86_64/x64/g') && \
  wget -q https://update.code.visualstudio.com/latest/linux-deb-${ARCH}/stable -O vs_code.deb && \
  apt-get update && \
  apt-get install -y ./vs_code.deb && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*  

RUN \
  sed -i 's#/usr/share/code/code#/usr/share/code/code --no-sandbox##' /usr/share/applications/code.desktop && \
  mkdir /$HOME/Desktop && \
  cp /usr/share/applications/code.desktop $HOME/Desktop && \
  chmod +x $HOME/Desktop/code.desktop && \
  chown 1000:1000 $HOME/Desktop/code.desktop && \
  rm vs_code.deb

COPY /root /

RUN \
  chmod 744 /etc/s6-overlay/s6-rc.d/*/run
