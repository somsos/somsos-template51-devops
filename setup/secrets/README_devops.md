# ReadMe shared folder

## Required files in this folder

The following files are required for the SSH setup:

```sh
./setup/secrets
├── t51_noPass.priv
└── t51_noPass.pub
```

for security reasons
I do not include it in the repository, so 

## How to generate them

```shell
# at root project level
ssh-keygen -t ed25519 -N '' -f  ./setup/secrets/t51_noPass.priv
mv ./setup/secrets/t51_noPass.priv.pub ./setup/secrets/t51_noPass.pub
```
