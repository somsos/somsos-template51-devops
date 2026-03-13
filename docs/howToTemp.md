# How to temporal

## How to recreate build in Jenkins

1. Using an workspace to test quick in local.
2. Clone DevOps project
3. Clone desired project in the desired path
4. Run build
5. Run deploy

Folder structure

```c
' Workspace
  - back
    - 1                               '/* Clone of DevOps project */ '
      - .env
      - docker-compose.yml
      - build-back.log                '/* start with basic info as: date, commit, user etc */ '
      - app/
        - docker-compose-app.yml
          - back
            - Dockerfile              '/* File with instructions of build and deploy */ '
            - source/                 '/* Clone of Back project */ '
              - target/...
    - 2
      - ...                           '/* Same as above */ '
  - front
    - 1                               '/* SAME IDEA OF ABOVE  */ '
    - 2
  - dbMig
    - 1
    - 2
```

##
