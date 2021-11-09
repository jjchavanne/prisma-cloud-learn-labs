# Prisma Cloud API Tutorial Part - GET Request

# IN DRAFT - NEEDS TO BE REFACTORED

Building on Lab 1, we will now fetch some data from Prisma Cloud

## 0 - Getting Started

## TODO: Review prereqs, such as Vault, access key, any env variables, etc.

Verify the script we created in Lab 1 works in your terminal.  If you skipped Lab 1 (or simply forgot about it already), you can still pickup right here.   
You will need this script saved as a file: `prisma_api_test.sh`.  


The script should look like this:

```bash
#!/bin/bash

pcee_API_URL=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.pcee_api_url)
pcee_ACCESS_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.pcee_accesskey)
pcee_SECRET_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.pcee_secretkey)

pcee_AUTH_PAYLOAD="{\"password\": \"$pcee_SECRET_KEY\", \"username\": \"$pcee_ACCESS_KEY\"}"

# NOTICE THE -s I've added to this call. This quiets the command
pcee_AUTH_TOKEN=$(curl -s --request POST \
                          --url "${pcee_API_URL}/login" \
                          --header 'content-type: application/json; charset=UTF-8' \
                          --data "${pcee_AUTH_PAYLOAD}" | jq -r '.token')
                          
# Print the output of the Token we should have received from the Curl request above.
echo "${pcee_AUTH_TOKEN}"  
```

The output of your command should produce a long string of random characters which represent a JWT token.
   
If you do not get this, verfiy the following:
## TODO: Add verification steps.


## 1 - Perform a GET Request

For this next step we will add a GET request into our original script in order to fetch some other data.
   
Before we do this though, let's cleanup and remove the following the last few lines from our previous script: 
```
# Check the output

echo "${pcee_AUTH_TOKEN}"
```




If you visit the [Prisma Cloud API Docs](https://prisma.pan.dev/api/cloud/cspm/cspm-api) and go to any of the CSPM API Endpoints and view a GET Request sample under 'Shell + Curl' you will notice they all look the same except for one piece, which is the actual API endpoint URL suffix in the URL field.   
   
> Example 1: the [List Compliance Standards GET](https://prisma.pan.dev/api/cloud/cspm/compliance-standards#operation/get-all-standards) Request sample
```
curl --request GET \
  --url https://api.prismacloud.io/compliance \
  --header 'x-redlock-auth: REPLACE_KEY_VALUE'
```

> Example 2: the [Enterprise Settings GET](https://prisma.pan.dev/api/cloud/cspm/settings#operation/get-enterprise-settings) Request sample
```
curl --request GET \
  --url https://api.prismacloud.io/settings/enterprise \
  --header 'x-redlock-auth: REPLACE_KEY_VALUE'
```  

To make it easier to work in our script, we will insert three variables and a new header to retreive the data in json format.  
1. Replace `https://api.prismacloud.io` with our API variable: `${pcee_API_URL}`
2. Replace `REPLACE_KEY_VALUE` with the AUTH_TOKEN variable we created in the last step: `${pcee_AUTH_TOKEN}`
3. Replace the text after the `/` after the API prefix in the URL field with this new one: `${API_ENDPOINT_SUFFIX}`
4. Add a `\` at the end of the third line and a new header field `--header 'Accept: application/json'` on the fourth line
   
The updated code block should look like this:

```bash
curl --request GET \
     --url "${pcee_API_URL}/${API_ENDPOINT_SUFFIX}" \
     --header "x-redlock-auth: ${pcee_AUTH_TOKEN}" \
     --header 'Accept: application/json'
```
   
## 2 - Calling your script to retreive data

There! Much better! Let's copy that code block into our clipboard and paste it back into our script. `nano prisma_api_test.sh`

As we did in the first lab, we'll also want to quiet the output of our api calls by adding a `-s` after the `curl command`.

After pasting the modified request back into the script and adding the `-s` to our `curl` commands, our script should now look like the code block below:

```bash
#!/bin/bash

pcee_API_URL=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.pcee_api_url)
pcee_ACCESS_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.pcee_accesskey)
pcee_SECRET_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.pcee_secretkey)

pcee_AUTH_PAYLOAD="{\"password\": \"$pcee_SECRET_KEY\", \"username\": \"$pcee_ACCESS_KEY\"}"

pcee_AUTH_TOKEN=$(curl -s --request POST \
                          --url "${pcee_API_URL}/login" \
                          --header 'content-type: application/json; charset=UTF-8' \
                          --data "${pcee_AUTH_PAYLOAD}" | jq -r '.token')

# HERE'S OUR MODIFIED REQUEST with an added -s 

curl -s --request GET \
        --url "${pcee_API_URL}/${API_ENDPOINT_SUFFIX}" \
        --header "x-redlock-auth: ${pcee_AUTH_TOKEN}" \
        --header 'Accept: application/json'
```        
   
_TIP: instead of `-s` you might try `-v` to your curl command if you don't get the expected response. `-v` enables verbose mode which will allow you to see the HTTP code that is returned. This can greatly help when debugging_

Hit `ctrl + x` then `y` to save and exit. 
   
Before we can call our script again, we need to export the new `API_ENDPOINT_SUFFIX` environment variable we just added.  To test this out, we will pick a simple one, [Enterprise Settings - GET](https://prisma.pan.dev/api/cloud/cspm/settings#operation/get-enterprise-settings)
   
In your terminal, set the variable to the API Endpoint suffix from the docs.  In this test case it's: `settings/enterprise` 
```
export API_ENDPOINT_SUFFIX="settings/enterprise"
```
   
Invoke our script again with bash, but this time we'll add `| jq` so it "pretty prints" the output. 

```bash
bash prisma_api_test.sh | jq
```

Let's test another API Endpoint.  Change your enviroment variable for [List Compliance Standards - GET](https://prisma.pan.dev/api/cloud/cspm/compliance-standards#operation/get-all-standards) request.   
In terminal: 
```
export API_ENDPOINT_SUFFIX="compliance"
```
In this case, we have a lot of data.  Let's send the output to a `temp.json` file so we can understand what we want to look at it.
```
bash prisma_api_test.sh | jq > temp.json
```

## TODO: Add some more content here to demonstrate some filtering or other API calls.
