#!/bin/bash

if [[ $# < 1 ]]; then
	echo "Usage: tpc-test.sh [num_slaves]"
	exit 1
fi

# Semantic value
NUM_SLAVES="$1"

echo "Purging docker containers..."
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

echo "Building docker images"
docker-compose build

echo "Starting master..."
docker run -itd --name "dbie-master" dbie_master bash

# Get scripts directory (for robustness)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

echo "Starting slaves..."
bash $DIR/spawn-slaves.sh $NUM_SLAVES

echo "Beginning test..."
docker exec dbie-master bash create-slavelist.sh $NUM_SLAVES
docker exec dbie-master rpcbind
docker exec -it dbie-master make tpc_test
