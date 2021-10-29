# Prisma Cloud API Tutorial - POST Requests

Building on Lab 2, we will now push or POST some data to Prisma Cloud.

## Objectives:
1. Create a service account
2. Demonstrate performing API POST Requests to Prisma Cloud
3. Demonstrate some useful POST examples a user can add to their toolbox

## 0 - Getting Started

In the previous labs, you likely were using a User Account to perform API requests.  This however is not ideal for programmatic access.  In this lab, we are going to show you a recommended way.  Programmatic access = Service Account

Assuming you are a Prisma Cloud Administrator yourself, follow the instructions to [Create a new service account](https://docs.paloaltonetworks.com/prisma/prisma-cloud/prisma-cloud-admin/manage-prisma-cloud-administrators/add-service-account-prisma-cloud.html) and give it 'System Admin' access.

### Environment Variables

With your new service account, next set the following environment variables, replacing the TEXT between the "" with your info:
```
export API_URL="<YOUR_TENANT_API_URL>"
export ACCESS_KEY="<YOUR_ACCESS_KEY>"
export SECRET_KEY="<YOUR_SECRET_KEY>"
```

## TODO: Add note about bash history here.

### Copy/Create API script

Verify the script we created in Lab 1 or 2 works in your terminal.  If you skipped previous labs (or simply forgot about them already), you can still pickup right here.   

In fact, we will make a copy of the script made from Lab 1 and make a new file.   
If needed first create the directory and cd into it.  If you did the previous labs, you should already have this directory.
   
```
mkdir pc_api_scripts
cd pc_api_scripts
```

Create a new file: `pc_access_key_rotation.sh` 

Paste the below into your script:

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
                          
# Print the output of the Token we should have received from the Curl request above.
echo "${pcee_AUTH_TOKEN}"   
```

### Test the script in your terminal:

First, make your script executable:
```
chmod u+x pc_access_key_rotation.sh
```

Run the script:
```
./pc_access_key_rotation.sh
```

The output of your command should produce a long string of random characters which represent a JWT token.
   
If you do not get this, verfiy you environment variables are correct and that you have access to Prisma Cloud API from your terminal.  If you have VPN access enabled (i.e. Global Protect), you may need to disable.


## Add POST Request 

