# TODO

##

Try to clone the project using ssh with the added public key to gitea
because i need in the script to not ask for credentials to clone the
projects of devops and either back or front to build/deploy using
the docker-compose.yml


curl -X POST -i \
  --header "Content-Type: application/json" \
  --data '{"repository": { "name": "template51-backend" }}' \
  http://localhost:3001/generic-webhook-trigger/invoke
