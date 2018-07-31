#!/bin/bash

if [[ $# < 1 ]]; then
	echo "Usage: slave-err-logs.sh [num_slaves]"
	exit 1
fi

let "NUM_SLAVES=$1"

for (( i = 0; i < $NUM_SLAVES; i++ )); do
	echo "dbie-slave-$i"
	docker exec "dbie-slave-$i" cat /root/dbie/distributed-system/bin/err.log
done
