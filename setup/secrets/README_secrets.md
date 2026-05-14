# Secrets directory

- [Secrets directory](#secrets-directory)
  - [Generate public and private keys for ssh](#generate-public-and-private-keys-for-ssh)
  - [Generate registry.password](#generate-registrypassword)

For security reasons, I do not include the following files, so we need to
generate this files.

```sh
./setup/secrets
├── t51_noPass.priv
├── t51_noPass.pub
└── registry.password
```

## Generate public and private keys for ssh

The following files are required for the SSH setup:

```shell
# at root project level
ssh-keygen -t ed25519 -N '' -f  ./setup/secrets/t51_noPass.priv
mv ./setup/secrets/t51_noPass.priv.pub ./setup/secrets/t51_noPass.pub
```

## Generate registry.password

To generate the "registry.password" file in this folder, we use the following
command

```bash
# at root project level
docker run --rm httpd:2 htpasswd -Bbn ${MY_USER} ${MY_PASS} >> ./setup/registry/registry.password
```
