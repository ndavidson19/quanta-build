#!/bin/bash

source scripts/utils.sh

init

log "Running Ansible playbook..."
ansible-playbook ansible/configure_eks.yml -i ansible/inventory

if [ $? -eq 0 ]; then
    log "Ansible playbook executed successfully"
else
    log "Error: Ansible playbook execution failed"
    exit 1
fi