#!/bin/sh
empq # empty message queue
cd distributed-system/
rpcbind
make tpc_test
