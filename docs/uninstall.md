# How to uninstall

```shell
docker compose --profile all down

docker volume rm t51_t51DB_vol1

rm -fv ./.env

rm -rfv setup/secrets/registry.password setup/secrets/ssh_key.priv setup/secrets/ssh_key.pub setup/gitea/vol-config-dir/app.ini

sudo rm -rf setup/jenkins/vol-jenkins_home/ && git restore setup/jenkins/vol-jenkins_home
rm -rf setup/gitea/vol-data && git restore setup/gitea/vol-data
rm -rf setup/nexus/vol-data && git restore setup/nexus/vol-data/0vol-data.md

# delete the added host
sudo nano /home/mario/.ssh/config
sudo nano /home/mario/.ssh/known_hosts
sudo nano /etc/hosts





# In case of having these errors:
#   - "Error response from daemon: RWLayer of container ... is unexpectedly nill"
#   - ""
docker container prune
docker builder prune -af
docker buildx prune -af
docker images -f dangling=true -q | xargs docker rmi
docker image prune -af
# Description: Running "docker compose up ..." gives this error.
# Most probable causes
#   - docker metadata corruption
#   - interrupted container creation
#   - a container references an invalid image layer
#   - Incompatible Docker version state

# 
docker buildx ls
```


