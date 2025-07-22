# README

## ToDo

Check the deploy process now in jenkins using web hook triggered by gitea.

## Requirements to change in the docker host

### Unblock the following ports

```bash
sudo ufw allow 3000
sudo ufw allow 222
sudo ufw allow 3001
sudo ufw allow 5432
sudo ufw allow 8080
sudo ufw allow 80

#So the connection doesn't freeze instead notify is being rejected/refused.
sudo ufw default reject incoming
```

### Changes in the host

Add the new line `127.0.0.1       host.docker.internal` on /etc/hosts
so the scripts connect the same way inside the container or in host.



### Jenkins plugins

Install the plugins

- [gitea](https://plugins.jenkins.io/gitea/)
- [custom](https://plugins.jenkins.io/generic-webhook-trigger/)

### Jenkins Jobs

1. Create a freestyle job
2. Check Generic Webhook Trigger
3. Add in POST token parameter: name: "TRIGGERING_REPO" expression: "$.repository.name"
4. Add token (same as webhook): 71c27113071788c2f7874f58a584d1138a003693
5. In build steps add "Execute shell" and peste the contant of start.sh 
    (comment the declaration of TRIGGERING_REPO)
6. (Optional) You can trigger the web hook manually like this

```shell
# Note the "Content-Type" header is important.

# name: template51_frontend - template51_backend
curl -X POST --data '{"repository": { "name": "template51_backend" }}' \
    -H "Content-Type: application/json" \
    http://host.docker.internal:3001/generic-webhook-trigger/invoke?token=71c27113071788c2f7874f58a584d1138a003693
```

## Pitfalls

### When starting jenkins 'Wrong volume permissions'

Can not write to /var/jenkins_home/copy_reference_file.log. Wrong volume permissions?" when I try to start my jenkins container?

**Solution:** Change the permissions of the directory to the id 1000, which is by default user
the jenkins container use.

```bash
sudo chown -R 1000:1000 ./data_jenkins
```

## Endpoints for checking

```sh
curl -X POST -i \
  --header "Content-Type: application/json" \
  --data '{"username":"mario1","password":"mario1p"}' \
  http://host.docker.internal:8080/auth/create-token
```
