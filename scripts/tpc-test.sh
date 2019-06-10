#!/bin/bash

if [[ $# < 1 ]]; then
	echo "Usage: tpc-test.sh [num_slaves]"
	exit 1
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Semantic value
NUM_SLAVES="$1"

echo "Purging docker containers..."
docker stop $(docker ps -aq) &> /dev/null
docker rm $(docker ps -aq) &> /dev/null

echo "Building docker images"
cd $DIR/..
docker-compose build

echo "Starting master..."
docker run -itd \
	--mount "type=bind,source=/home/jahrme/Documents/dbie-data/,destination=/root/dbie/dbie-data/" \
	--name "dbie-master" dbie:prod bash

echo "Starting slaves..."
bash $DIR/spawn-slaves.sh $NUM_SLAVES

echo "Beginning test..."
docker exec dbie-master rpcbind

docker exec dbie-master bash create-slavelist.sh $NUM_SLAVES
docker exec -it dbie-master /root/dbms
bash $DIR/get-csv.sh dbie-master
