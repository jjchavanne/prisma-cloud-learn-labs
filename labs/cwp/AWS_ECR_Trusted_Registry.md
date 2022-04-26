# Setup & Enforce Trusted ECR Registries with Prisma Cloud

These set of instructions are written to incorporate several components of Prisma Cloud and typical DevOps workflows for building and deploying container images.    

## Tasks and tools chosen for this lab:
*NOTE: Many of the tools chosen for this lab, such as registries, CI Tools, and VCS can be swapped for other common choices, such as Jenkins, Gitlab, Docker registry to name a few examples.  Prisma Cloud integrates with many popular DevOps tools. Where noted in* **Bold** *below, indicates a tool that was only chosen as one of many other options.*

- Setting up Image Registries
    - **AWS ECR**
- Setting up and Enforcing Trusted Registries & Base Images rules in Prisma Cloud
- Integrate Registry with a VCS
    - **GitHub**
- Integrate a CI Tool to automatically ONLY push secure/compliant images to trusted registry
    - AWS ECR **Github Action** 
- Setup Prisma Cloud Compute/Defend rules 
- Integrate a CI Tool to do automatic scanning of images when Pull Requests are made to the repo.   
    - Prisma Cloud **GitHub Action** scans that automatically pass/fail image scans based on Rules
- Setup branch protection rules in **GitHub** to only allow images that PASS scans to be merged 


## Prerequisites
1. Have an AWS account with proper permissions to create new IAM roles, policy bindings, ECR repos.
2. Access to Prisma Cloud tenant with permissions to set Compute rules and integrations
3. Have a Github account

## Create ECR Repos
- We will create 2 repos, one to be trusted and one not to be trusted.

1. TODO - add link to steps to create ECR


## Setup EC2 instance with Amazon ECR Docker Credential Helper
- TODO - relocate [this](https://github.com/jjchavanne/cheat-sheets/blob/main/aws/Setup_EC2_Instance_&_Amazon_ECR_Docker_Credential_Helper.md) to a public repo

## Integrate with a VCS Lab
- TODO - add info about using a repo with GitHub Action to push safe images to ECR.
