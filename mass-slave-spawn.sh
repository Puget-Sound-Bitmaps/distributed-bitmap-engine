#!/bin/bash
[ $# -lt 1 ] && echo "Usage: ./fulltst.sh num_slaves" && exit 0
# DO NOT RUN THIS IF YOU'RE NOT ALREADY RUNNING MASTER!!!
for (( i=0; i<$1; i++ )); do
    echo "Starting slave $i"
    docker run dbie ./start-slave.sh &
done
