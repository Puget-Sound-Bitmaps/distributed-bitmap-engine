#!/bin/bash

# DO NOT RUN THIS IF YOU'RE NOT ALREADY RUNNING MASTER!!!

if [[ $# < 1 ]]; then
	echo "Usage: spawn-slaves.sh [num_slaves] [optional: starting_index]"
	exit 1
fi

# Determine start and stop values
let "NUM_SLAVES=$1"
let "START=0"
if [[ $# > 1 ]]; then
	let "START=$2"
fi
let "STOP=$START+$NUM_SLAVES"

# Spawn slaves
for (( i = $START; i < $STOP; i++ )); do
	docker run -itd --name "dbie-slave-$i" dbie_slave
done
