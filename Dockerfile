FROM ubuntu:16.04
WORKDIR /root
EXPOSE 80

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get dist-upgrade -y
RUN apt-get auto-remove -y
RUN apt-get auto-clean -y

# install dependencies

# java
#RUN apt-get -y install default-jdk
# python
#RUN apt-get -y install python
#RUN apt-get -y install python-dev
RUN apt-get -y install python3
#RUN apt-get -y install python3-dev
# C compiler
RUN apt-get -y install gcc
# RPC
RUN apt-get -y install libc-dev-bin
RUN apt-get -y install rpcbind
# OpenSSL
RUN apt-get -y install libssl-dev
# Shell
RUN apt-get -y install make
RUN apt-get -y install git
RUN apt-get -y install vim
RUN apt-get -y install valgrind

# source code
COPY . distributed-bitmap-engine/

# vimrc
ADD https://raw.githubusercontent.com/smburdick/dotfiles/master/.vimrc .vimrc

WORKDIR /root/distributed-bitmap-engine/distributed-system
RUN make

WORKDIR /root/distributed-bitmap-engine/
RUN chmod 755 start-slave.sh tpc-test.sh distributed-system/vcnt.sh .setup.sh \
    create-slavelist.sh

