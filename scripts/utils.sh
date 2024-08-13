#!/bin/bash

# Function to log messages
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check required tools
check_requirements() {
    local requirements=("docker" "docker-compose" "kubectl" "yq" "aws" "terraform" "ansible")
    for req in "${requirements[@]}"; do
        if ! command_exists "$req"; then
            log "Error: $req is not installed. Please install it and try again."
            exit 1
        fi
    done
}

# Function to load environment variables from a file
load_env() {
    if [ -f ".env" ]; then
        export $(cat .env | xargs)
    fi
}

# Call this at the beginning of each script
init() {
    check_requirements
    load_env
}