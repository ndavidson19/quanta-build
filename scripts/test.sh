#!/bin/bash

source scripts/utils.sh

# Read microservices from config
microservices=$(yq e '.microservices[]' config/ci-cd-config.yaml)

for service in $microservices; do
  name=$(echo $service | yq e '.name' -)
  docker_compose=$(echo $service | yq e '.docker_compose' -)
  makefile=$(echo $service | yq e '.makefile' -)

  echo "Testing $name..."

  # Run tests using Docker Compose
  docker-compose -f "$name/$docker_compose" run --rm $name npm test

  # Run make test if Makefile exists
  if [ -f "$name/$makefile" ]; then
    make -C "$name" test
  fi
done