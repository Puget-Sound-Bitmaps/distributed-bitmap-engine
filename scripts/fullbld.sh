#!/bin/bash
echo "Building image"
docker build -t dbie .
echo "Running tmux"
./tmux-dbie.sh $1
