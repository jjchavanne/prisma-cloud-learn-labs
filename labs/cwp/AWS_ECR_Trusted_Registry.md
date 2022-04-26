# Setup both Trusted & Untrusted ECR Registries with Prisma Cloud

These set of instructions are written to incorporate several components of Prisma Cloud and typical DevOps workflows with the following:

- Setting up Image Registries
    - will use AWS ECR for this lab
- Setting up and Enforcing Trusted Registries & Base Images
    - Integrate and setup Trusted Registry rule in Prisma Cloud
- Integrate Registry with a VCS
    - will use integration with GitHub for this lab
- Integrate a CI Tool to automatically ONLY push secure/compliant images to trusted registry
    - will use a Github Action for this lab
- Integrate a CI Tool to do automatic scanning of images when Pull Requests are made to the repo.
    - Integrate and setup Prisma Cloud Compute/Defend rules 
    - setup branch protection rules in GitHub to only allow images to be merged that pass Prisma Cloud scan tests

## Prerequisites
1. Have an AWS account with proper permissions to create new IAM roles, policy bindings, ECR repos.
2. Access to Prisma Cloud tenant with permissions to set Compute rules and integrations

## Create ECR Repos
- We will create 2 repos, one to be trusted and one not to be trusted.

1. TODO - add link to steps to create ECR


## Setup EC2 instance with Amazon ECR Docker Credential Helper
- TODO - relocate [this](https://github.com/jjchavanne/cheat-sheets/blob/main/aws/Setup_EC2_Instance_&_Amazon_ECR_Docker_Credential_Helper.md) to a public repo

## Integrate with a VCS Lab
- TODO - add info about using a repo with GitHub Action to push safe images to ECR.
