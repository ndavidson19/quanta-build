#!/bin/bash

source scripts/utils.sh

init

ACTION=$1
FLAG_NAME=$2
FLAG_VALUE=$3

case $ACTION in
  set)
    if [ -z "$FLAG_NAME" ] || [ -z "$FLAG_VALUE" ]; then
      log_error "Flag name and value are required for 'set' action."
      exit 1
    fi
    yq e ".feature_flags[] |= select(.name == \"$FLAG_NAME\").default = $FLAG_VALUE" -i config/ci-cd-config.yaml
    log_success "Feature flag '$FLAG_NAME' set to '$FLAG_VALUE'"
    ;;
  get)
    if [ -z "$FLAG_NAME" ]; then
      log_error "Flag name is required for 'get' action."
      exit 1
    fi
    value=$(yq e ".feature_flags[] | select(.name == \"$FLAG_NAME\").default" config/ci-cd-config.yaml)
    if [ -z "$value" ]; then
      log_warning "Feature flag '$FLAG_NAME' not found."
    else
      log_info "Feature flag '$FLAG_NAME' is set to '$value'"
    fi
    ;;
  list)
    log_info "Listing all feature flags:"
    yq e '.feature_flags[]' config/ci-cd-config.yaml
    ;;
  *)
    log_error "Usage: $0 {set|get|list} [flag_name] [flag_value]"
    exit 1
    ;;
esac