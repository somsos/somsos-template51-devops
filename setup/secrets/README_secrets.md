# Secrets directory

- [Secrets directory](#secrets-directory)
  - [Generate public and private keys for ssh](#generate-public-and-private-keys-for-ssh)
  - [Generate registry.password](#generate-registrypassword)

For security reasons, I do not include the following files, so we need to
generate this files.

```sh
./setup/secrets
├── ssh_key.priv
├── ssh_key.pub
└── registry.password
```

## Generate public and private keys for ssh

The following files are required for the SSH setup:

```shell
# at root project level
ssh-keygen -t ed25519 -N '' -f  ./setup/secrets/ssh_key.priv
mv ./setup/secrets/ssh_key.priv.pub ./setup/secrets/ssh_key.pub
```

## Generate registry.password

To generate the "registry.password" file in this folder, we use the following
command

Note: The content we see after the user name is a one-way cryptographic hash.

```bash
# at root project level
docker run --rm httpd:2 htpasswd -Bbn ${MY_USER} ${MY_PASS} >> ./setup/registry/registry.password
```
