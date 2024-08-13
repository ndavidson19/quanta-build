#!/bin/bash

source scripts/utils.sh

ENV=$1
STRATEGY=${2:-"rolling"}  # Default to rolling update

if [ -z "$ENV" ]; then
  echo "Environment not specified"
  exit 1
fi

# Read microservices and environment config
microservices=$(yq e '.microservices[]' config/ci-cd-config.yaml)
domain=$(yq e ".environments[] | select(.name == \"$ENV\") | .domain" config/ci-cd-config.yaml)

for service in $microservices; do
  name=$(echo $service | yq e '.name' -)
  
  echo "Deploying $name to $ENV..."

  case $STRATEGY in
    rolling)
      kubectl set image deployment/$name $name=$name:latest --namespace $ENV
      ;;
    blue-green)
      # Implement blue-green deployment logic
      ;;
    canary)
      # Deploy canary version (10% of traffic)
      sed -e "s/{{SERVICE_NAME}}/$name/" -e "s/{{IMAGE_TAG}}/latest/" templates/k8s-deployment-canary.yaml | kubectl apply -f - --namespace $ENV
      kubectl scale deployment/$name-canary --replicas=1 --namespace $ENV
      kubectl scale deployment/$name --replicas=9 --namespace $ENV
      ;;
    *)
      echo "Unknown deployment strategy: $STRATEGY"
      exit 1
      ;;
  esac

  # Update ingress or service as needed
  kubectl apply -f templates/k8s-service.yaml --namespace $ENV
done

# Update ingress with new domain
sed -i "s/host:.*/host: $domain/" templates/k8s-ingress.yaml
kubectl apply -f templates/k8s-ingress.yaml --namespace $ENV