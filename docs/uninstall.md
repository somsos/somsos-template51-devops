# How to uninstall

```shell
docker compose --profile all down

sudo rm -rfv setup/secrets/registry.password setup/secrets/ssh_key.priv setup/secrets/ssh_key.pub setup/gitea/vol-config-dir/app.ini

sudo rm -rf setup/jenkins/vol-jenkins_home/ && git restore setup/jenkins/vol-jenkins_home
sudo rm -rf setup/gitea/vol-data && git restore setup/gitea/vol-data

# delete the added host
sudo nano /home/mario/.ssh/config
sudo nano /home/mario/.ssh/known_hosts
sudo nano /etc/hosts

# In case of having this error:
# "Error response from daemon: RWLayer of container abc... is unexpectedly nill"
docker container prune -af
docker builder prune -af
docker image prune -af
docker buildx prune -af
# Description: Running "docker compose up ..." gives this error.
# Most probable causes
#   - docker metadata corruption
#   - interrupted container creation
#   - a container references an invalid image layer
#   - Incompatible Docker version state

# 
docker buildx ls
```