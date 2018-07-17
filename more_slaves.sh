#!/bin/bash
[ $# -lt 2 ] && \
    echo "Usage: ./more_slaves.sh [curr_slave_index] [num_slaves]" && exit 0
let "m=$1+$2"
tmux new-session -s "slave$1" -n "slave$1" -d "docker run -it dbie /bin/bash"
for (( i=$1+1; i<$1+$2; i++ )); do
    tmux new-window -d -n "slave$i" "docker run -it dbie /bin/bash"
    tmux send-keys -t "slave$i" \
        "./create-slavelist.sh 1024" Enter \
        "rpcbind && cd distributed-system/bin" Enter \
        "./slave" Enter
done
