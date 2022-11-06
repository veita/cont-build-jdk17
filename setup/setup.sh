#!/bin/bash

set -ex

export DEBIAN_FRONTEND=noninteractive

apt-get update -qy
apt-get upgrade -qy
apt-get install -qy \
    locales \
    lsb-release \
    wget \
    curl \
    gnupg2 \
    less \
    vim \
    screen \
    ripgrep \
    tree \
    unzip \
    zip \
    htop \
    mc \
    file \
    binutils \
    git \
    openjdk-17-jdk-headless \
    fontconfig \
    make \
    autoconf \
    build-essential \
    libx11-dev \
    libxext-dev \
    libxrender-dev \
    libxrandr-dev \
    libxtst-dev \
    libxt-dev \
    libcups2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libasound2-dev \
    libffi-dev


# system configuration: locales
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
echo 'de_DE.UTF-8 UTF-8' >> /etc/locale.gen
/usr/sbin/locale-gen

# global shell configuration
sed -i 's/# "\\e\[5~": history-search-backward/"\\e\[5~": history-search-backward/g' /etc/inputrc
sed -i 's/# "\\e\[6~": history-search-forward/"\\e\[6~": history-search-forward/g' /etc/inputrc

sed -i 's/SHELL=\/bin\/sh/SHELL=\/bin\/bash/g' /etc/default/useradd

sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /etc/skel/.bashrc

# global vim configuration
sed -i 's/"syntax on/syntax on/g' /etc/vim/vimrc
sed -i 's/"set background=dark/set background=dark/g' /etc/vim/vimrc

# global screen configuration
sed -i 's/#startup_message off/startup_message off/g' /etc/screenrc
echo 'shell /bin/bash' >> /etc/screenrc

# shell settings for root
source /setup/root-bashrc.sh >> /root/.bashrc

# vim settings for root
echo 'set mouse-=a' > /root/.vimrc

# add custom trusted CA certificates
if [ ls /setup/trusted-ca-certificates/*.crt &> /dev/null ] ; then
    mkdir /usr/share/ca-certificates/custom
    cp /setup/trusted-ca-certificates/*.crt /usr/share/ca-certificates/custom
    find /usr/share/ca-certificates/custom -name '*.crt' -printf 'custom/%f\n' >> /etc/ca-certificates.conf
    /usr/sbin/update-ca-certificates
fi

# create project directory
mkdir -p /qsk/jdk

# install jtreg
JTREG_URL="https://ci.adoptopenjdk.net/view/Dependencies/job/dependency_pipeline/lastSuccessfulBuild/artifact/jtreg/jtreg-7+1.tar.gz"
curl $JTREG_URL | tar --one-top-level=/opt -xz

# cleanup
source /setup/cleanup-image.sh
