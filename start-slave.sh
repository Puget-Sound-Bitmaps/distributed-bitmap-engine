#!/bin/sh
# create a slavelist for a large number of slaves
./create-slavelist.sh 1024
cd distributed-system/bin/
rpcbind
./slave
#make spawn_slave
