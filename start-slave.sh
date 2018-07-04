#!/bin/sh
# create a slavelist for a large number of slaves
./create-slavelist.sh 128
cd distributed-system/
rpcbind
make spawn_slave
