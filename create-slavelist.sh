#!/bin/bash
# Generate a list of slave IP addresses. For Docker, they are presumed to start
# at 172.17.0.3
cd distributed-system/
# Delete slavelist if it exists
[ -e SLAVELIST ] && rm SLAVELIST
let "i=3"
let "max=$1+3"
while [ $i -lt $max ]; do
    echo "172.17.0.$i" >> SLAVELIST
    let "i++"
done
