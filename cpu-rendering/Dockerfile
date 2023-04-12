FROM ubuntu:focal

LABEL author="Marcin Bielak <marcin.bieli+github@gmail.com>"

ENV BLENDER_BIN_VERSION_MIROR=2.93
ENV BLENDER_BIN_VERSION=2.93.16


RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
      wget \
      ca-certificates \
      apt-utils \
      gnupg \
      software-properties-common \
      p7zip-full \
      xvfb \
      curl \
      wget \
      xz-utils \
      uuid-runtime \
      apt-transport-https \
      libpng16-16 \
      libnvtt-dev \
      libgconf-2-4 \
      libfontconfig1

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
      libx11-6 \
      libxi6 \
      libxxf86vm1 \
      libxxf86vm-dev \
      libxfixes-dev \
      libxrender1 \
      libgl1 \
      libgles1 \
      mesa-utils

RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc && chmod 755 /usr/local/bin/mc

WORKDIR /opt/blendtemp

RUN wget https://mirrors.dotsrc.org/blender/release/Blender${BLENDER_BIN_VERSION_MIROR}/blender-${BLENDER_BIN_VERSION}-linux-x64.tar.xz
RUN ls -la
RUN tar -xvf blender-${BLENDER_BIN_VERSION}-linux-x64.tar.xz
RUN mv blender-${BLENDER_BIN_VERSION}-linux-x64 /opt/blender


WORKDIR /opt/blender

VOLUME /opt/blender_data/output

#COPY render.sh /usr/local/sbin
COPY render.sh /bin

ENTRYPOINT [ "bash", "/bin/render.sh" ]

#RUN apt-get remove -y xvfb p7zip-full gnupg curl
RUN apt-get autoremove -y
RUN apt-get autoclean -y
