#!/bin/bash
xhost local:root
XSOCK=/tmp/.X11-unix

docker run -it \
  --runtime=nvidia \
 -e DISPLAY=$DISPLAY \
 -v $XSOCK:$XSOCK \
 -v $HOME/.Xauthority:/root/.Xauthority \
 --privileged \
 --net=host \
 --name=baseros2 \
 baseros2:latest bash

