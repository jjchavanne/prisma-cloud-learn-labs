# Prisma Cloud API Tutorial - POST Requests

Building on Lab 2, we will now push or POST some data to Prisma Cloud.

## Objectives:
1. Demonstrate performing API POST Requests to Prisma Cloud
2. Demonstrate common useful POST examples, such as Access Key rotation that a user can add to their toolbox

## 0 - Getting Started

## TODO: Cleanup Vault, access key, any env variables, etc.

Verify the script we created in Lab 1 or 2 works in your terminal.  If you skipped previous labs (or simply forgot about them already), you can still pickup right here.   

We will make a copy of the script made from Lab 2 and make a new file.   
First cd into your Prisma Cloud API script folder

## TODO: provide details on folder here:

Create a new file: `pc_access_key_rotation.sh`.  


The script should look like this:

```bash
#!/bin/bash

pcee_API_URL=$API_URL
pcee_ACCESS_KEY=$ACCESS_KEY
pcee_SECRET_KEY=$SECRET_KEY

pcee_AUTH_PAYLOAD="{\"password\": \"$pcee_SECRET_KEY\", \"username\": \"$pcee_ACCESS_KEY\"}"

# NOTICE THE -s I've added to this call. This quiets the command
pcee_AUTH_TOKEN=$(curl -s --request POST \
                          --url "${pcee_API_URL}/login" \
                          --header 'content-type: application/json; charset=UTF-8' \
                          --data "${pcee_AUTH_PAYLOAD}" | jq -r '.token')
                          
 
```

### Environment Variables

export API_URL="<YOUR_TENANT_API_URL>"
export ACCESS_KEY="<YOUR_ACCESS_KEY>"
export SECRET_KEY="<YOUR_SECRET_KEY>"

The output of your command should produce a long string of random characters which represent a JWT token.
   
If you do not get this, verfiy the following:
## TODO: Add verification steps.
