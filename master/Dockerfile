FROM ubuntu:16.04
WORKDIR /dbie/distributed-system
ADD . /dbie
EXPOSE 80

RUN apt-get update --yes
RUN apt-get upgrade --yes
RUN apt-get dist-upgrade --yes
RUN apt-get auto-remove --yes
RUN apt-get auto-clean --yes

RUN apt-get --yes install default-jdk
RUN apt-get --yes install python
RUN apt-get --yes install python-dev
RUN apt-get --yes install python3
RUN apt-get --yes install python3-dev
RUN apt-get --yes install gcc
RUN apt-get --yes install libc-dev-bin
RUN apt-get --yes install libssl-dev
RUN apt-get install make --yes


CMD ["make", "basic_test"]
