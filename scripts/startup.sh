#!/bin/bash

echo "Building and Starting Distributed Bitmap Engine"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

# Rebuild and run necessary preparatory commands.
sudo rpcbind

cd $DIR/distributed-system

# Fist argument is the type of node [master|slave]
NODETYPE=$1

# Assign binary file depending on argument, quitting if invalid.
if [[ $NODETYPE == "slave" ]]
then
    make spawn_slave
elif [[ $NODETYPE == "master" ]]
then
    make basic_test
else
    echo "`$NODETYPE` is not a valid argument."
    echo "Usage: startup.sh [master|slave]"
    exit 1
fi
