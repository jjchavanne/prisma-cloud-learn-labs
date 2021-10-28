# Prisma Cloud API Tutorial - Part 1
   
**Learn how to securely automate tasks with the Prisma Cloud API**

This lab uses one of our [Secrets Management tool building blocks].   I'm choosing to use Vault in 'Dev' mode for this tutorial, however because these labs are written in a modular fashion, you can swap out for another Secrets Management method if you desire.  
![alt text](../../images/secrets-bash-2.jpg)

## Objectives:
1. Create a bash script to automate interaction with the Prisma Cloud API
2. Utilize jq for processing and filtering JSON data retreived from Prisma Cloud
3. Utilize a Secrets Managment tool to store and retreive Access Keys


## Prerequisites:
- access to a Prisma Cloud tenant
- terminal shell (i.e. bash or zsh)
- install [Vault](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started)
- install [jq](https://stedolan.github.io/jq/download/)

## Getting Started:
   
### Obtain Values for the following keys:

| **Key** | **Value** | **How To Obtain** |
| ------------------ | --------------------- | ---------------- |
| **pcee_api_url** | **'https://<API_URL>'** | *Visit [Prisma PAN API Docs](https://prisma.pan.dev/api/cloud/api-urls) to map your tenant URL to the API URL.* |
| **pcee_accesskey** | **'<YOUR_ACCESS_KEY>'** | *Log into Prisma Cloud and go to Settings > Access Keys* |
| **pcee_secretkey** | **'<YOUR_SECRET_KEY>'** | *Obtain your Secret Key at time of Access Key creation.* |

### Step 1: Create Secret and store Access Key info in Vault

*NOTE: For this step we will only be showing you how to utlize Vault in **'Dev'** mode.  This is NOT recommended for production use, however much simplier to learn and use for the purposes of this tutorial.  See [Deploy Vault Tutorial](https://learn.hashicorp.com/tutorials/vault/getting-started-deploy?in=vault/getting-started) and [Seal/Unseal Concepts](https://www.vaultproject.io/docs/concepts/seal) to learn how to use Vault for a production environment.*
   
Additional Reading for better understanding options:
- https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1#bebe
- https://www.beyondtrust.com/blog/entry/secrets-management-overview-7-best-practices 
- https://www.csoonline.com/article/3624577/securing-cicd-pipelines-6-best-practices.html
- https://docs.aws.amazon.com/secretsmanager/latest/userguide/best-practices.html
   

TODO: Determine best approach for this step or provide user the option to choose based on here:
https://learn.hashicorp.com/tutorials/vault/static-secrets#q-how-do-i-enter-my-secrets-without-exposing-the-secret-in-my-shell-s-history
- Option 1: Write directly in shell
- Option 2: Use a dash"-"
- Option 3: Read from a file
- Option 4: Disable vault command history (in addition to one of the above)


Using dev mode, start the dev server:
```
vault server -dev
```

Open a new terminal and create the secret with the three pieces of key/value data (replacing the <TEXT> of each value with your values):
In your terminal:

```bash
vault kv put secret/prisma_enterprise_env \
             pcee_api_url='https://<API_URL_FROM_LINK_ABOVE>' \
             pcee_accesskey='<YOUR_ACCESS_KEY>' \
             pcee_secretkey='<YOUR_SECRET_KEY>'
```
