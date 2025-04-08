# Setting up and building docker images

## Requirements
* Install docker tools 
  * In GNU/Linux: [:link:](https://docs.docker.com/engine/install) and [:link:](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04).
  * In Mac or Windows: [:link:](https://www.docker.com/products/docker-desktop/).


## Using terminal in GNU/Linux OS distributions
### Build docker image
* Building estimated time will depend on internet speed connetion
```
#cd root path of repo
cd docs/docker
docker compose -f docker-compose.yml build
```

### Checking built docker image
```
docker images
#REPOSITORY   TAG     IMAGE ID      CREATED         SIZE
baseros2      latest  <ID>          <time lenght>         23.1GB
```

### Launch and test docker image
```
bash launch_image.bash

# source ROS environment
source /opt/ros/humble/setup.bash
# sanity checks and display topics
ros2 wtf
ros2 topic list

type `exit` to exit container
```

### Stop container and remove it
```
bash stop_container_and_removeit.bash
```

## Using [Visual Studio Code](https://code.visualstudio.com/)
1. Open your project VSCode that requires [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers&ssr=false#review-details) extension. Once project is open in VSCode you will automatically see and click `Reopen in Container`.

## MacOS

Using the provided Dockerfile and devcontainer setup on macOS has some limitations due to the lack of GPU passthrough and X11 support. However, you can still use the container to develop ROS2 applications with some adjustments.

### Limitations:
1. **No NVIDIA GPU Passthrough:**
   - macOS does not support passing an NVIDIA GPU to Docker containers. As a result, GPU-dependent features, such as the ZED SDK, cannot be used inside the container.
   
2. **No XAUTHORITY Support:**
   - X11 forwarding is not supported on macOS.

### Adjustments for macOS:
To make the container work on macOS, you need to comment out or remove certain lines in the Dockerfile and devcontainer.json:

1. **In the Dockerfile:**
   - Comment out the lines related to the ZED SDK. See the relevant section in the [Dockerfile](../../.devcontainer/Dockerfile#L73-L79).

2. **In devcontainer.json:**
   - Comment out or remove the lines related to GPU and XAUTHORITY. See the relevant section in [devcontainer.json](../../.devcontainer/devcontainer.json#L18-L23).

## References
### Few useful commands to manage your docker images
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
sudo systemctl restart docker
```

### Change Name of My Docker Repository and Rename Images
```
#Please replace the existing image name as well as new repository name  
docker tag <existing_image>:<tag> <new_repository>:<tag>

#Removing the Old Image
docker rmi <existing_image>:<tag> 
```



### Docker Hub usage and limits
See [usage](https://docs.docker.com/docker-hub/usage/) for an overview of the included usage and limits (e.g. Pull rate limit per 6 hours is 100 per IPv4 address or IPv6 /64 subnet for Unauthenticated users using).
