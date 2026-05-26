# How to uninstall

```shell
docker compose --profile all down

sudo rm -rfv setup/secrets/registry.password setup/secrets/ssh_key.priv setup/secrets/ssh_key.pub setup/gitea/vol-config-dir/app.ini

sudo rm -rfv setup/jenkins/vol-jenkins_home/ && git restore setup/jenkins/vol-jenkins_home
sudo rm -rfv setup/gitea/vol-data && git restore setup/gitea/vol-data

# delete the added host
sudo nano /home/mario/.ssh/config
sudo nano /home/mario/.ssh/known_hosts
sudo nano /etc/hosts

```