#!/bin/bash

# Copy all CSV files from given container to local directory
[[ ! $# -eq 1 ]] && echo "Usage: get-csv.sh [container_name]" && exit 0
CONTAINER_NAME="$1"

# Get directory of script file (and by extension the output directory)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
OUT="$DIR/../exp-out"

# Temp directory for copying
TMP="/tmp/dbie"

# Ensure output and temp directories exist
mkdir -p "$OUT"
mkdir -p "$TMP"

# Copy whole bin directory from container to temp
docker cp $CONTAINER_NAME:/root/dbie/distributed-system/bin/ $TMP

# Copy just csv files from temp to exp-out
for CSV in $TMP/bin/*.csv; do
	cp $CSV $OUT
done

# Empty temp
[ -e $TMP/bin/ ] && rm -rf $TMP/bin/
