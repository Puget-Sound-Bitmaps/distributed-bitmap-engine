#!/bin/bash

echo "Building and Starting Distributed Bitmap Engine"
DIR=/tmp/dbe

# Fist argument is the type of node [master|slave]
NODETYPE=$1

# Assign binary file depending on argument, quitting if invalid.
if [[ NODETYPE == "master" ]]
then
    BINARY="dbms"
elif [[ NODETYPE == "slave" ]]
then
    BINARY="slave"
else
    echo "`$1` is not a valid argument."
    echo "Usage: startup.sh [master|slave]"
    exit 1
fi

# Rebuild and run necessary preparatory commands.
sudo rpcbind

cd $DIR/bitmap-engine
make

cd $DIR/distributed-system
make

cd $DIR/distributed-system/bin
./$BINARY
