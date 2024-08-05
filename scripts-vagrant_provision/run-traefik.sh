#!/bin/bash

# DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#shellcheck disable=SC2046
export $(grep -v '^#' /vagrant/.env | xargs -d '\n')

# permissions fix on the folder
DIRECTORY=/vagrant/gateways/docker/traefik/logs
if [ ! -d "${DIRECTORY}" ]; then
  mkdir -p "${DIRECTORY}"
  chown vagrant:vagrant "${DIRECTORY}" 
  chmod 644 "${DIRECTORY}" 
fi

# make sure acme.json exists as file before first run
touch /vagrant/gateways/docker/certs/acme.json

cd /vagrant/gateways/docker || exit 1

docker-compose up -d
docker-compose config > current-config.yml
