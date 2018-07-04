#!/bin/sh
./create-slavelist.sh $1
# empty message queue
ipcrm -q $(ipcs -q | grep 666 | tr -s " " | cut -d " " -f 2)
cd distributed-system/
rpcbind
make tpc_test
