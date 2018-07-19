#!/bin/bash
[[ ! $# -eq 2 ]] && echo "Usage: ./getcsv.sh [NAME] [FILE]" && exit 0
[[ ! -e exp-out/ ]] && mkdir exp-out/
docker cp $1:/root/distributed-bitmap-engine/distributed-system/bin/$2 exp-out/
