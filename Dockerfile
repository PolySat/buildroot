FROM ubuntu:bionic

RUN dpkg --add-architecture i386

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  build-essential \
  git-core \
  ssh \
  cpio \
  bison \
  bc \
  util-linux \
  flex \
  gettext \
  texinfo \
  wget \
  python \
  python3-pip \
  unzip \
  rsync \
  ca-certificates \
  libc6:i386 \
  libncurses5:i386 \
  libstdc++6:i386 \
  locales \
  --no-install-recommends \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/man /usr/share/doc \
  && locale-gen en_US.utf8

RUN git clone https://github.com/PolySat/polyxdr.git /polyxdr
RUN cd /polyxdr && pip3 install --upgrade setuptools && python3 /polyxdr/setup.py install

RUN  echo "    StrictHostKeyChecking=no" >> /etc/ssh/ssh_config
