#!/bin/bash

source scripts/utils.sh

ACTION=$1
FLAG_NAME=$2
FLAG_VALUE=$3

case $ACTION in
  set)
    yq e ".feature_flags[] |= select(.name == \"$FLAG_NAME\").default = $FLAG_VALUE" -i config/ci-cd-config.yaml
    ;;
  get)
    yq e ".feature_flags[] | select(.name == \"$FLAG_NAME\").default" config/ci-cd-config.yaml
    ;;
  list)
    yq e '.feature_flags[]' config/ci-cd-config.yaml
    ;;
  *)
    echo "Usage: $0 {set|get|list} [flag_name] [flag_value]"
    exit 1
    ;;
esac