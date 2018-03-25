FROM ubuntu:trusty

RUN dpkg --add-architecture i386

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential \
  git-core \
  ssh \
  bison \
  util-linux \
  flex \
  gettext \
  texinfo \
  wget \
  python \
  unzip \
  rsync \
  ca-certificates \
  libc6:i386 \
  libncurses5:i386 \
  libstdc++6:i386 \
  --no-install-recommends \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man /usr/share/doc

RUN locale-gen en_US.utf8
RUN  echo "    StrictHostKeyChecking=no" >> /etc/ssh/ssh_config
