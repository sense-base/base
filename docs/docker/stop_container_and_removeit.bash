docker stop $(docker ps -a -q)
docker system prune -f --volumes
