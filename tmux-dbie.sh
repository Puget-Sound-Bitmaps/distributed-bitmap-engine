#!/bin/bash

# To detach from tmux, enter: control+b d
# To close all tmux windows, run on the command line: "tmux kill-server"
# To ensure all containers are stopped (for IP reasons), either run
# "docker stop $(docker ps -a -q)" or manually stop all dbie containers


# Command to start docker shell
DOCKER_SHELL='docker run -it dbie /bin/bash'

# Quit if insufficient arguments
if [[ $# -lt 1 ]] ; then
    echo "Usage: tmux-dbie.sh [num_slaves]"
    exit 0
fi

# Semantics
let "num_slaves=$1"

# Quit if insufficient arguments
if [[ $num_slaves -lt 2 ]] ; then
    echo "DBIE requires at least 2 slaves."
    exit 0
fi

# Kill master and slave containers
docker stop `docker ps -q`
#docker stop `docker ps -q | grep "^\(master$\)\|slave[[:digit:]]$"`
tmux kill-session -t "dbie"
# Create detached session named dbie with a shell window named master
tmux new-session -s "dbie" -n "master" -d "$DOCKER_SHELL"

# To ensure master gets IP: 172.17.0.2
sleep 1

# Create the slaves
for (( i=0; i<$num_slaves; i++ )); do
    tmux new-window -d -n "slave$i" "$DOCKER_SHELL"
    tmux send-keys -t "slave$i" \
        "./create-slavelist.sh 1024" Enter \
        "rpcbind && cd distributed-system/bin" Enter \
        "./slave" Enter
done

let "st_denom=6"
let "sleep_time=$num_slaves/$st_denom"

# Prep master
# XXX: wait for all slaves to come online with sleep?
tmux send-keys -t "master" \
    "sleep 5" Enter \
    "time ./tpc-test.sh '$num_slaves'"

# Attach to session
tmux attach-session -t "dbie"
