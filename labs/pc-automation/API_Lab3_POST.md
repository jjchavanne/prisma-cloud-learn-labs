# Prisma Cloud API Tutorial - POST Requests

Building on Lab 2, we will now push or POST some data to Prisma Cloud.

## Objectives:
1. Create a service account
2. Demonstrate performing API POST Requests to Prisma Cloud
3. Demonstrate some useful POST examples a user can add to their toolbox

## 0 - Getting Started

In the previous labs, you likely were using a User Account to perform API requests.  This however is not ideal for programmatic access.  In this lab, we are going to show you a recommended way.  Service Account

Assuming you are a Prisma Cloud Administrator yourself, follow the instructions to [Create a new service account](https://docs.paloaltonetworks.com/prisma/prisma-cloud/prisma-cloud-admin/manage-prisma-cloud-administrators/add-service-account-prisma-cloud.html) and give it 'System Admin' access.

Write down the following values you enter, as you will need these again later:

## TODO: add value table here.

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

## TODO: Insert the Account Group Post request first as an easier starting point.  Then build into the Access key one after.






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

Visit the Prisma Cloud API Docs and navigate to the [Access Keys -> Add Access Key - POST](https://prisma.pan.dev/api/cloud/cspm/access-keys#operation/add-access-keys) request page.
   
Scroll down to the **Request samples** section and copy and paste the `Shell + Curl` sample to the end of your script:

```
curl --request POST \
  --url https://api.prismacloud.io/access_keys \
  --header 'x-redlock-auth: REPLACE_KEY_VALUE' \
  --data '{"expiresOn":0,"name":"string","serviceAccountName":"string"}'
```  

Let's edit this and replace some pieces of data with variables and info:

The first few lines are easy, because it is entering values we have used before.
   
Replace `https://api.prismacloud.io` with `${pcee_API_URL}`   
Replace `REPLACE_KEY_VALUE` with `${pcee_AUTH_TOKEN}`

The `--data` field is similar to what we did in Lab 1.  This is a payload field that we need to inject data into.
   
There are three fields to submit.  Looking at the [API docs](https://prisma.pan.dev/api/cloud/cspm/access-keys#operation/add-access-keys), Prisma Cloud expects the body schema to be `application/json` and the following values:

- **expiresOn** = *integer* \<int64> Timestamp in milliseconds when access key expires.  #Meaning this will need to be future dated.  
- **name** = *string* Access key name
- **serviceAccountName** = *string* Service account name

Let's convert each field:
TODO: explain the time field

TODO: Explain the other variables


Finally we will create a new payload variable: `pcee_ACCESS_KEY_PAYLOAD`

TODO: Finish explaining


Here is the finally code block:
```
pcee_ACCESS_KEY_PAYLOAD="{\"expiresOn\":$((`date '-v+60d' '+%s'`*1000)),\"name\":\"$ACCESS_KEY_NAME\",\"serviceAccountName\":\"$SA_NAME\"}"

curl -v --request POST \
     --url "${pcee_API_URL}/access_keys" \
     --header 'content-type: application/json' \
     --header "x-redlock-auth: ${pcee_AUTH_TOKEN}" \
     --data "${pcee_ACCESS_KEY_PAYLOAD}" 
```     

