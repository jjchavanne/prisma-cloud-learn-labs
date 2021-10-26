# Prisma Cloud API Tutorial - Part 1
   
**Goal: Learn how to securely automate tasks with the Prisma Cloud API

## Objectives:
1. Utilize Hashicorp Vault, an open source Secrets Manager to securely store and retreive Access Keys
2. Create a bash script to securely automate interaction with the Prisma Cloud API
3. Utilize jq for processing and filtering JSON data retreived from Prisma Cloud

## Prerequisites:
- access to a Prisma Cloud tenant
- terminal shell (i.e. bash or zsh)
- install [Vault](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started)
- install [jq](https://stedolan.github.io/jq/download/)

## Getting Started:

The following key values will be required:

| **Key** | **Value** | **How To Obtain** |
| ------------------ | --------------------- | ---------------- |
| **pcee_api_url** | **'https://<API_URL>'** | *Visit [Prisma PAN API Docs](https://prisma.pan.dev/api/cloud/api-urls) to map your tenant URL to the API URL.* |
| **pcee_accesskey** | **'<YOUR_ACCESS_KEY>'** | *Log into Prisma Cloud and go to Settings > Access Keys* |
| **pcee_secretkey** | **'<YOUR_SECRET_KEY>'** | *Obtain your Secret Key at time of Access Key creation.* |

