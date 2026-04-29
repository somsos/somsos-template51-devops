# Read me

In this folder goes all related with the registry container.


To generate the "registry.password" file in this folder, we use the following
command

```bash
# Using docker
docker run --rm httpd:2 htpasswd -Bbn ${MY_USER} ${MY_PASS} > ./registry/auth/registry.password

# or installing "apache2-utils"
htpasswd -Bbn ${MY_USER} ${MY_PASS} > ./registry.password
```
