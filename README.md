# README

## ToDo

Re-start service when is already up, because the re-build I undestand already
happens because whn something changes re-builds.
But when is already up do not re-start, so that might make the changes are not deploy.
So change to a command that restart or detect if is running and if it's running stop


## Requirements

### Jenkins plugins

Install the plugins

- [gitea](https://plugins.jenkins.io/gitea/)
- [custom](https://plugins.jenkins.io/generic-webhook-trigger/)

### Jenkins Jobs

1. Create a freestyle job
2. Check Generic Webhook Trigger
3. Add token (same as webhook): 71c27113071788c2f7874f58a584d1138a003693
4. In Post content parameters, configure:

## Pitfalls

### When starting jenkins 'Wrong volume permissions'

Can not write to /var/jenkins_home/copy_reference_file.log. Wrong volume permissions?" when I try to start my jenkins container?

**Solution:** Change the permissions of the directory to the id 1000, which is by default user
the jenkins container use.

```bash
sudo chown -R 1000:1000 ./data_jenkins
```
