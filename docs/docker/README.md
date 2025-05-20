# Getting started with Docker images and ROS 2 package builds

## Requirements
### Software
* Laptop with GNU/Linux Ubuntu 22.04 LTS (Jammy Jellyfish). See [release cycle](https://ubuntu.com/about/release-cycle).
* Install docker tools 
  * In GNU/Linux: [:link:](https://docs.docker.com/engine/install) and [:link:](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04).
  * In Mac or Windows: [:link:](https://www.docker.com/products/docker-desktop/).
* ROS2 [Humble Hawksbill](https://docs.ros.org/en/foxy/Releases/Release-Humble-Hawksbill.html). See [List of Distributions](https://docs.ros.org/en/foxy/Releases.html#list-of-distributions).

### Hardware 
* GPU-laptop
* ZED Stereo Camera
* g.USBAMP RESEARCH

## Setting up ros2-based packages in the workspace

```bash
git clone git@github.com:sense-base/base.git
cd base
mkdir -p workspace/src && cd workspace/src
git@github.com:sense-base/sense_eeg.git
git@github.com:sense-base/sense_msgs.git
```

## Using `Visual Studio Code` either on GNU/Linux Ubuntu
Open your project [VSCode](https://code.visualstudio.com/) that requires [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers&ssr=false#review-details) extension. 
Once the project is open in VS Code, you will see a prompt to `Reopen in Container`. 
Click it to start building the container. 
After that, open a terminal to begin working inside the container.

## Launch docker image initalise rosdep
To initialise rosdep, run:
```bash
(ros2_ws) root@:/ros2_ws# bash rosdep-init.bash 
```

Once that's done, you can continue with the usual steps:
```bash
colcon build --symlink-install
source install/setup.bash
ros2 launch eeg_publisher mock_publisher_launch.py
```

## Useful commands in terminal
* Checking built docker image
```bash
docker images
#REPOSITORY   TAG     IMAGE ID      CREATED         SIZE
baseros2      latest  <ID>          <time lenght>         23.1GB
```

* Stop container and remove it
```bash
bash stop_container_and_removeit.bash
```

## MacOS (not fully supported)
Using the provided Dockerfile and devcontainer setup on macOS has some limitations due to the lack of GPU passthrough and X11 support. 
However, you can still use the container to develop ROS2 applications with some limitations and adjustments.
* Limitations:
   * **No NVIDIA GPU Passthrough**: macOS does not support passing an NVIDIA GPU to Docker containers. As a result, GPU-dependent features, such as the ZED SDK, cannot be used inside the container.
   * **No XAUTHORITY Support:** X11 forwarding is not supported on macOS.

* Container Adjustments for macOS:
   * **In the Dockerfile:** Comment out the lines related to the ZED SDK. See the relevant section in the [Dockerfile](../../.devcontainer/Dockerfile).
   * **In devcontainer.json:** Comment out or remove the lines related to GPU and XAUTHORITY. See the relevant section in [devcontainer.json](../../.devcontainer/devcontainer.json).

## References
### Few useful commands to manage your docker images
```bash
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
```bash
#Please replace the existing image name as well as new repository name  
docker tag <existing_image>:<tag> <new_repository>:<tag>

#Removing the Old Image
docker rmi <existing_image>:<tag> 
```

### Docker Hub usage and limits
See [usage](https://docs.docker.com/docker-hub/usage/) for an overview of the included usage and limits (e.g. Pull rate limit per 6 hours is 100 per IPv4 address or IPv6 /64 subnet for Unauthenticated users using).
