#!/bin/bash
[ $# -lt 1 ] && echo "Usage: ./tpc-test.sh [num_slaves]" && exit 0
./create-slavelist.sh $1
# empty message queue
ipcrm -q $(ipcs -q | grep 666 | tr -s " " | cut -d " " -f 2)
cd distributed-system/
rpcbind
make tpc_test
