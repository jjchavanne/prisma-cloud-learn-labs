# Prisma Cloud REST API Tutorial - Part 1
   
**Learn how to get up and running with the Prisma Cloud REST APIs**

This tutorial will use **cURL**.  It is the simplest and fastest way to interact with REST APIs.  

## Objectives:
1. Utilize Environment Variables to store and retreive Access Keys.
2. Create a bash script using cURL to automate requests with the Prisma Cloud REST API.
3. Utilize jq for processing and filtering JSON data retreived from Prisma Cloud.


## Prerequisites:
- access to a Prisma Cloud tenant
- terminal shell (i.e. bash or zsh)
- install [jq](https://stedolan.github.io/jq/download/)
- familiarity with a [text editor or IDE](../../tools/Text_Editors.md) (i.e. nano, vim, VSCode)
- Obtain Values for the following keys:

| **Key** | **Value** | **How To Obtain** |
| ------------------ | --------------------- | ---------------- |
| **PC_API_URL** | **'https://<YOUR_TENANT_API_URL>'** | *Visit [Prisma PAN API Docs](https://prisma.pan.dev/api/cloud/api-urls) to map your tenant URL to the tenant API URL.* |
| **PC_ACCESS_KEY** | **'<YOUR_ACCESS_KEY>'** | *Log into Prisma Cloud and go to Settings > Access Keys* |
| **PC_SECRET_KEY** | **'<YOUR_SECRET_KEY>'** | *Obtain your Secret Key at time of Access Key creation.* |

## 1 - Setup Secrets Management 

I'm choosing to Create Secret and store Access Key info in Vault in Dev mode.
   
Feel free to choose another Secrets Management option.  
TODO: Refer to other options.
   
   
*NOTE: Using Vault in **'Dev'** mode is NOT recommended for production use, however much simplier to learn and use for the purposes of this tutorial.  See [Deploy Vault Tutorial](https://learn.hashicorp.com/tutorials/vault/getting-started-deploy?in=vault/getting-started) and [Seal/Unseal Concepts](https://www.vaultproject.io/docs/concepts/seal) to learn how to use Vault for a production environment.*
   

Using dev mode, start the dev server:
```
vault server -dev
```

Before proceeding, suggest to review and consider [Keeping your secrets out of your Bash History](../secrets-mgmt/Keeping_Secrets_Out_Of_Bash_History.md
)
   
Launch a new terminal window and Copy the `export VAULT_ADDR ...` command from the first terminal output and run in the second terminal window.  
   
> **Example:**
```
export VAULT_ADDR='http://127.0.0.1:8200'
```

Save the unseal key somewhere. Don't worry about how to save this securely. For now, just save it anywhere.

Set the `VAULT_TOKEN` environment variable value to the generated **Root Token** value displayed in the terminal output.   
   
> **Example:**
```
export VAULT_TOKEN='s.XmpNPoi9sRhYtdKHaQhkHP6x'
```
   
To verify the server is running:
```
vault status
```

Using your Prisma Cloud key/values, create the secret with the three pieces of key/value data (replacing the '\<TEXT>' of each value with your values):
In your terminal:

```bash
vault kv put secret/prisma_enterprise_env \
             PC_API_URL='https://<YOUR_TENANT_API_URL>' \
             PC_ACCESS_KEY='<YOUR_ACCESS_KEY>' \
             PC_SECRET_KEY='<YOUR_SECRET_KEY>'
```
   
With jq installed, verify retreiving your secret data:
```
vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_API_URL
vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_ACCESS_KEY
vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_SECRET_KEY
```

## 2 - Create Prisma Cloud API Script

First, create a new project directory and cd into it:
```
mkdir prisma_api_dir
cd prisma_api_dir/
```
   
Next, create a new file with your favorite [text editor](../../tools/Text_Editors.md).
> **Example with nano:**
```
nano prisma_api_test.sh
```

The first line we'll type in our script is a she-bang. This ensures our script is interpreted correctly.

```bash
#!/bin/bash
```

Next we'll define our variables inside our script.
   
Note, we are using mixed_CASE here so as not to be confused with environment or bash variables (typically UPPERCASE) plus these variables relate to the vault key names with the same name and we want to differentiate these variable names by using mixed_CASE.  For more explanation see this [stakoverflow article](https://stackoverflow.com/questions/673055/correct-bash-and-shell-script-variable-capitalization) 

```bash
#!/bin/bash

PC_API_URL=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_API_URL)
pcee_ACCESS_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_ACCESS_KEY)
pcee_SECRET_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_SECRET_KEY)
```

The last variable we need to define for now is the payload variable.

There's multiple ways to do this and pros and cons to each. 

For simplicity's sake, I'm going to create this variable in the script so you only have one file to worry about. The downsides to this method are: 

1. the script is less readable and
2. you have to be more sensitive to the formatting

Here's our json payload we'll need to send with our first api call:
```json
{
  "password": "string",
  "username": "string"
}
```

The problem is, bash won't interpret that correctly if we assigned the raw json to a variable. To get around this we'll need to reformat the raw json so it's it's interpreted correctly. 

_TIP: I use vim as my editor of choice. A simple shortcut is to leverage the stream editor capabilities of vim to do this quickly. If you're just learning how to work with the bash shell...stick with nano for now_

Here's how we'll define the last variable for our script. 

```bash 
#!/bin/bash

PC_API_URL=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_API_URL)
pcee_ACCESS_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_ACCESS_KEY)
pcee_SECRET_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_SECRET_KEY)

pcee_AUTH_PAYLOAD="{\"password\": \"$pcee_SECRET_KEY\", \"username\": \"$pcee_ACCESS_KEY\"}"
```

Now we're ready to make our first api call using curl. 

Let's go to the [Prisma Pan API Documentation Page](https://prisma.pan.dev/api/cloud/cspm/login#operation/app-login) to retrieve the api endpoint we'll need. In this case, the api endpoint we want is `/login`.

We'll copy out the request sample from the `Shell + Curl` tab on the right-hand of the documentation page and paste it into our script. 

_Note: the `#` comments out the line in bash. I'll use that indicate what I'm doing_

```bash
#!/bin/bash

PC_API_URL=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_API_URL)
pcee_ACCESS_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_ACCESS_KEY)
pcee_SECRET_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_SECRET_KEY)

pcee_AUTH_PAYLOAD="{\"password\": \"${pcee_SECRET_KEY}\", \"username\": \"${pcee_ACCESS_KEY}\"}"

# HERE'S WHAT WE COPIED FROM THE DOCUMENTATION PAGE:

curl --request POST \
  --url https://api.prismacloud.io/login \
  --header 'content-type: application/json; charset=UTF-8'
```

We'll need to change the request sample so it works with our script. First, we'll clean up the formatting and then replace the url with our `$PC_API_URL` variable + the api endpoint `/login`. 


_Note: the `\` is used to break the line for readability...but ultimately isn't necessary. When using a `\` it's important to be mindful of extra spaces after the `\`_

Many people who are first learning bash have issues with the spacing and formatting because they're not thinking about how the code is interpreted. Example:

```bash
curl --request POST \
  --url https://api.prismacloud.io/login \
  --header 'content-type: application/json; charset=UTF-8'
```

Is the same as:
```bash
curl --request POST --url https://api.prismacloud.io/login --header 'content-type: application/json; charset=UTF-8'
```

_TIP: Sometimes it's easier to make it all one line and then add the `\` in as needed. This ensure's you don't have weird spacing issues when scripting._

The last modification we'll need to add is the request body or data from our json payload. `--data ${pcee_AUTH_PAYLOAD}`

Here's what your script should look like after we add the variables in and clean up the formatting:

```bash
#!/bin/bash

PC_API_URL=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_API_URL)
pcee_ACCESS_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_ACCESS_KEY)
pcee_SECRET_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_SECRET_KEY)

pcee_AUTH_PAYLOAD="{\"password\": \"$pcee_SECRET_KEY\", \"username\": \"$pcee_ACCESS_KEY\"}"

# HERE'S WHAT WE COPIED FROM THE DOCUMENTATION PAGE:

curl --request POST \
     --url "${PC_API_URL}/login" \
     --header 'content-type: application/json; charset=UTF-8' \
     --data "${pcee_AUTH_PAYLOAD}"
```

## 3 - Save your script and execute it!

In our scripts current form we should be able to invoke it and retrieve the JWT (JSON Web Token; pronouced: JOT). 

Let's test it out! Hit `ctrl + x` and then `y` to save your script. 

Execute it from the terminal by entering: `bash prisma_api_test.sh`. You should get a response that looks like this:

```json
{"token":"<SUPER_LONG_STRING>","message":"login_successful","customerNames":[{"customerName":"partnerdemo","tosAccepted":true}]}
```

Uh-oh...well that's pretty ugly and also unusable to pass downstream for more api calls. Let's start leveraging jq. Enter the same command you entered before but add `| jq` to the end of it. This will "pretty print" the response so we can understand how to filter it for later use. 

```bash
bash prisma_api_test.sh | jq
```

Now our response will look like this:

```json
{
  "token": "<SUPER_LONG_STRING>",
  "message": "login_successful",
  "customerNames": [
    {
      "customerName": "partnerdemo",
      "tosAccepted": true
    }
  ]
}
```

## 4 - Using JQ to filter and parse the JSON response

Okay...so now it's easier to look at. Let use jq to filter out the token which is what we'll need for our next api call. To do that, we will first need to break down what we want. Ideally, we want the `"value"` of the `"token"` key. To isolate the `"value (or <SUPER_LONG_STRING>)"` of the token key we'll modify our command to: 

```bash
bash prisma_api_test.sh | jq -r '.token'
```

_Note: the `-r` removes the quotes._

Now you have the TOKEN isolated! Perfect. Copy out the `| jq -r '.token'` from your terminal and edit your script again. We'll modify the script so it saves our first api call to another variable `$pcee_AUTH_TOKEN` which we'll then use in another api call.

So we can observe what's happening let's go ahead and `echo` the variable `$pcee_AUTH_TOKEN` at the end of our script.

Let's re-open our script in nano: `nano prisma_api_test.sh`. 

Our goal here is to assign the response to a variable named `$pcee_AUTH_TOKEN`. To do that we'll wrap our `curl` command in `$()` and then adjust the formatting for maintainability.

Finally, we'll add the `echo "${pcee_AUTH_TOKEN}"` to the end of our script so we can see that we've captured the JWT. 

```bash
#!/bin/bash

PC_API_URL=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_API_URL)
pcee_ACCESS_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_ACCESS_KEY)
pcee_SECRET_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_SECRET_KEY)

pcee_AUTH_PAYLOAD="{\"password\": \"$pcee_SECRET_KEY\", \"username\": \"$pcee_ACCESS_KEY\"}"

# HERE'S WHAT WE COPIED FROM THE DOCUMENTATION PAGE:

pcee_AUTH_TOKEN=$(curl --request POST \
                       --url "${PC_API_URL}/login" \
                       --header 'content-type: application/json; charset=UTF-8' \
                       --data "${pcee_AUTH_PAYLOAD}" | jq -r '.token')

# Check the output

echo "${pcee_AUTH_TOKEN}"
```

After your script looks like the code block above, hit `ctrl + x` then `y` on your keyboard to close and save the changes. 

Now it's time to invoke your script again. 

```bash
bash prisma_api_test.sh
```

You should see the curl progress and your JWT print out in the response. That's perfect. Now we can access all the other Prisma Cloud CSPM API's (It's a similar process with some minor tweaks when accessing the CWPP API.  We'll run through that in another tutorial).

## 5 - Quiet the Curl command

When performing automation, we may not want unnecessary output.  In this case we are going to mute the progress meter and error output.   

Edit the script one more time by adding a `-s` directly after the word `curl` in the command.   

Once edited, our script should now look like the code block below:

```bash
#!/bin/bash

PC_API_URL=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_API_URL)
pcee_ACCESS_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_ACCESS_KEY)
pcee_SECRET_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.PC_SECRET_KEY)

pcee_AUTH_PAYLOAD="{\"password\": \"$pcee_SECRET_KEY\", \"username\": \"$pcee_ACCESS_KEY\"}"

# NOTICE THE -s I've added to this call. This quiets the command
pcee_AUTH_TOKEN=$(curl -s --request POST \
                          --url "${PC_API_URL}/login" \
                          --header 'content-type: application/json; charset=UTF-8' \
                          --data "${pcee_AUTH_PAYLOAD}" | jq -r '.token')
                          
# Print the output of the Token we should have received from the Curl request above.
echo "${pcee_AUTH_TOKEN}"                          
```

Save the script and run one more time.

```bash
bash prisma_api_test.sh
```

### Congratulations!   
**You have created a base template that can now empower you to interact with Prisma Cloud programmatically.  This is a huge foundational piece that now makes it easy to do so much more.  Move on to the next lab in this series:**   
[API GET Requests](API_Lab2_GET_Request.md)
