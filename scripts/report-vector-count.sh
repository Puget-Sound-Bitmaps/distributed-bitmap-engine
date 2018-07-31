#!/bin/bash

# DO NOT RUN THIS IF YOU'RE NOT ALREADY RUNNING MASTER!!!

if [[ $# < 1 ]]; then
	echo "Usage: report-vector-count.sh [num_slaves]"
	exit 1
fi

let "NUM_SLAVES=$1"

for (( i = 0; i < $NUM_SLAVES; i++ )); do
	echo "dbie-slave-$i"
	docker exec "dbie-slave-$i" bash count-vectors.sh
done
