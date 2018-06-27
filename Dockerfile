FROM ubuntu:16.04
WORKDIR /root
EXPOSE 80

RUN apt-get update --yes
RUN apt-get upgrade --yes
RUN apt-get dist-upgrade --yes
RUN apt-get auto-remove --yes
RUN apt-get auto-clean --yes

# install dependencies

# java
#RUN apt-get --yes install default-jdk
# python
#RUN apt-get --yes install python
#RUN apt-get --yes install python-dev
RUN apt-get --yes install python3
#RUN apt-get --yes install python3-dev
# C compiler
RUN apt-get --yes install gcc
# RPC
RUN apt-get --yes install libc-dev-bin
RUN apt-get --yes install rpcbind
# OpenSSL
RUN apt-get --yes install libssl-dev
# Shell
RUN apt-get --yes install make
RUN apt-get --yes install git
RUN apt-get --yes install vim
RUN apt-get --yes install valgrind

# source code
COPY . distributed-bitmap-engine/

# vimrc
ADD https://raw.githubusercontent.com/smburdick/dotfiles/master/.vimrc .vimrc

WORKDIR /root/distributed-bitmap-engine
