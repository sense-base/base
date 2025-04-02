# Setting up and building docker images

## Requirements
* Install docker tools 
  * In linux: [:link:](https://docs.docker.com/engine/install) and [:link:](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04).
  * In mac or windows: [:link:](https://www.docker.com/products/docker-desktop/).

## Build docker image
* Building estimated time will depend on internet speed connetion
```
docker compose -f docker-compose.yml build
```

## Checking built docker image
```
docker images
#REPOSITORY   TAG     IMAGE ID      CREATED         SIZE
baseros2      latest  <ID>          <time lenght>         23.1GB
```

## Launch and test docker image
```
bash launch_image.bash

# source ROS environment
source /opt/ros/humble/setup.bash
# sanity checks and display topics
ros2 wtf
ros2 topic list

type `exit` to exit container
```

## Stop container and remove it
```
bash stop_container_and_removeit.bash
```

## Few usueful docker commands
```
docker images
docker ps
docker attach <ID>
docker stop <ID>
docker stop $(docker ps -a -q) # stop all containers
docker rename keen_einstein mycontainer
docker logs <ID> # display syslogs of the container
docker rmi --force <ID>
docker image prune -a #clean unused images
docker system prune -f --volumes #clean unused systems
docker inspect <container-name> (or <container-id>) 
```

