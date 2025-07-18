# README

## ToDo

Make the deploy.script works either in host or container, by changing the
way the network works (add host.docker.internal on host and container)

Make the conning in jenkins, I stayed on adding the ssh key from ./.secrets/ssh
as vlume to jenkins

```bash
cp ~/.ssh/id_ed25519 myproject/jenkins_ssh/
cp ~/.ssh/id_ed25519.pub myproject/jenkins_ssh/
chmod 600 myproject/jenkins_ssh/id_ed25519

  volumes:
    - ./jenkins_home:/var/jenkins_home
    - ./jenkins_ssh:/root/.ssh:ro
```

## Requirements

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
curl -X POST --data '{"repository": { "name": "Hi-There" }}' \
    http://localhost:3001/generic-webhook-trigger/invoke?token=71c27113071788c2f7874f58a584d1138a003693
```

## Pitfalls

### When starting jenkins 'Wrong volume permissions'

Can not write to /var/jenkins_home/copy_reference_file.log. Wrong volume permissions?" when I try to start my jenkins container?

**Solution:** Change the permissions of the directory to the id 1000, which is by default user
the jenkins container use.

```bash
sudo chown -R 1000:1000 ./data_jenkins
```
