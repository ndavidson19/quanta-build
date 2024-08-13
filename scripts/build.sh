#!/bin/bash

source scripts/utils.sh

# Read microservices from config
microservices=$(yq e '.microservices[]' config/ci-cd-config.yaml)

for service in $microservices; do
  name=$(echo $service | yq e '.name' -)
  repo=$(echo $service | yq e '.repo' -)
  docker_compose=$(echo $service | yq e '.docker_compose' -)
  makefile=$(echo $service | yq e '.makefile' -)

  echo "Building $name..."
  
  # Clone or update the repository
  if [ -d "$name" ]; then
    git -C "$name" pull
  else
    git clone "$repo" "$name"
  fi

  # Build using Docker Compose
  docker-compose -f "$name/$docker_compose" build

  # Run make if Makefile exists
  if [ -f "$name/$makefile" ]; then
    make -C "$name" build
  fi
done