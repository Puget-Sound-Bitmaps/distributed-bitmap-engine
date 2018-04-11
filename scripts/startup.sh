#!/bin/bash

echo "Building and Starting Distributed Bitmap Engine"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

# Rebuild and run necessary preparatory commands.
sudo rpcbind

cd $DIR/distributed-system

# Fist argument is the type of node [master|slave]
NODETYPE=$1

make

# Assign binary file depending on argument, quitting if invalid.
if [[ $NODETYPE == "slave" ]]
then
    echo "Starting slave..."
    cd $DIR/distributed-system/bin
    nohup ./slave &
elif [[ $NODETYPE == "master" ]]
then
    echo "Starting master..."
    cd $DIR/distributed-system/bin
    nohup ./dbms 0 &
else
    echo "`$NODETYPE` is not a valid argument."
    echo "Usage: startup.sh [master|slave]"
    exit 1
fi
