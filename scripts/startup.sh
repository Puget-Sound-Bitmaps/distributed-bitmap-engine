#!/bin/bash

echo "Building and Starting Distributed Bitmap Engine"
DIR="~/distributed-bitmap-engine"

# Rebuild and run necessary preparatory commands.
sudo rpcbind

cd $DIR/bitmap-engine
make

cd $DIR/distributed-system
make

# Fist argument is the type of node [master|slave]
NODETYPE=$1

# Assign binary file depending on argument, quitting if invalid.
if [[ NODETYPE == "slave" ]]
then
    make spawn_slave
elif [[ NODETYPE == "master" ]]
then
    make basic_test
else
    echo "`$1` is not a valid argument."
    echo "Usage: startup.sh [master|slave]"
    exit 1
fi
