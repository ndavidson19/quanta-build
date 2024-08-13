#!/bin/bash

# Set strict mode
set -euo pipefail

# Colors for logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
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
            log_error "$req is not installed. Please install it and try again."
            exit 1
        fi
    done
}

# Function to load environment variables from a file
load_env() {
    if [ -f ".env" ]; then
        set -a
        source .env
        set +a
    fi
}

# Function to validate environment
validate_environment() {
    local env=$1
    if [[ ! "$env" =~ ^(staging|production)$ ]]; then
        log_error "Invalid environment: $env. Must be 'staging' or 'production'."
        exit 1
    fi
}

# Initialize script
init() {
    check_requirements
    load_env
}