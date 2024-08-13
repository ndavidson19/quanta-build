# Quanta CI/CD System

This repository contains the CI/CD system for managing, building, deploying, and releasing the Quanta codebase, which is separated into multiple microservices.

## Features

- Microservices management
- Automated build and test processes
- Deployment to multiple environments (staging, production)
- Feature flag management
- Support for various deployment strategies (rolling, blue-green, canary)
- Infrastructure as Code using Terraform for AWS resources
- Cluster configuration using Ansible

## Prerequisites

- Docker and Docker Compose
- kubectl
- yq
- AWS CLI
- Terraform
- Ansible

## Getting Started

1. Clone this repository:
   ```
   git clone https://github.com/your-org/quanta-cicd.git
   cd quanta-cicd
   ```

2. Set up your AWS credentials:
   ```
   aws configure
   ```

3. Initialize Terraform:
   ```
   cd terraform/aws
   terraform init
   ```

4. Apply Terraform configuration:
   ```
   terraform apply
   ```

5. Update the `ansible/group_vars/all.yml` file with your specific configuration.

6. Run the Ansible playbook to configure the EKS cluster:
   ```
   ./scripts/run_ansible.sh
   ```

## Usage

### Building Microservices

To build all microservices:

```
./scripts/build.sh
```

### Deploying Microservices

To deploy microservices to an environment (e.g., staging or production):

```
./scripts/deploy.sh <environment> [deployment_strategy]
```

For example:

```
./scripts/deploy.sh staging
./scripts/deploy.sh production blue-green
```

### Managing Feature Flags

To set a feature flag:

```
./scripts/feature_flags.sh set <flag_name> <flag_value>
```

To get the value of a feature flag:

```
./scripts/feature_flags.sh get <flag_name>
```

To list all feature flags:

```
./scripts/feature_flags.sh list
```

### Running Tests

To run tests for all microservices:

```
./scripts/test.sh
```

### Running Ansible Playbook

To run the Ansible playbook to configure the EKS cluster:

```
./scripts/run_ansible.sh
```

## Directory Structure

```
quanta-cicd/
├── .github/
│   └── workflows/
│       └── main.yml
├── ansible/
│   ├── roles/
│   │   └── eks_config/
│   │       ├── tasks/
│   │       │   └── main.yml
│   │       └── templates/
│   │           ├── k8s-deployment.yaml.j2
│   │           ├── k8s-service.yaml.j2
│   │           └── k8s-ingress.yaml.j2
│   ├── ansible.cfg
│   ├── configure_eks.yml
│   ├── group_vars/
│   │   └── all.yml
│   └── inventory
├── config/
│   └── ci-cd-config.yaml
├── scripts/
│   ├── build.sh
│   ├── deploy.sh
│   ├── feature_flags.sh
│   ├── run_ansible.sh
│   ├── test.sh
│   └── utils.sh
├── templates/
│   ├── k8s-deployment-canary.yaml
│   ├── k8s-deployment.yaml
│   ├── k8s-ingress.yaml
│   ├── k8s-namespace.yaml
│   └── k8s-service.yaml
└── terraform/
    └── aws/
        ├── backend.tf
        ├── main.tf
        └── variables.tf
```

## Configuration Files

- `config/ci-cd-config.yaml`: Configuration file for microservices, environments, feature flags, deployment strategies, monitoring, and scaling.
- `config/staging.yaml`: Configuration file for the staging environment.
- `config/production.yaml`: Configuration file for the production environment.
- `ansible/group_vars/all.yml`: Variables for the Ansible playbook.

## Scripts

- `scripts/build.sh`: Script to build Docker images for all microservices.
- `scripts/deploy.sh`: Script to deploy services to different environments.
- `scripts/feature_flags.sh`: Script to manage feature flags.
- `scripts/run_ansible.sh`: Script to run the Ansible playbook.
- `scripts/test.sh`: Script to run tests for all microservices.
- `scripts/utils.sh`: Utility functions used by other scripts.

## Templates

- `templates/k8s-deployment-canary.yaml`: Kubernetes template for canary deployments.
- `templates/k8s-deployment.yaml`: Kubernetes template for deployments.
- `templates/k8s-ingress.yaml`: Kubernetes template for ingresses.
- `templates/k8s-namespace.yaml`: Kubernetes template for namespaces.
- `templates/k8s-service.yaml`: Kubernetes template for services.

## Terraform

- `terraform/aws/backend.tf`: Terraform backend configuration.
- `terraform/aws/main.tf`: Main Terraform configuration for AWS resources.
- `terraform/aws/variables.tf`: Variables for Terraform configuration.

## Ansible

- `ansible/roles/eks_config/tasks/main.yml`: Tasks for EKS configuration.
- `ansible/roles/eks_config/templates/*.yaml.j2`: Jinja2 templates for K8s resources.
- `ansible/ansible.cfg`: Ansible configuration.
- `ansible/configure_eks.yml`: Main Ansible playbook.
- `ansible/inventory`: Inventory file for Ansible.
