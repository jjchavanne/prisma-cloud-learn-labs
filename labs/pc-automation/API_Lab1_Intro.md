# Prisma Cloud REST API Tutorial - Part 1
   
**Learn how to get up and running with the Prisma Cloud REST APIs**

This tutorial will use **curl**.  It's simple, well known, and an easy way to interact with REST APIs.  

## Objectives:
1. Utilize Environment Variables to store and retreive Access Keys.
2. Create a bash script using curl to automate requests with the Prisma Cloud REST API.
3. Utilize jq for processing and filtering JSON data retreived from Prisma Cloud.


## Prerequisites:
- basic understanding of REST APIs, JSON, curl and it's main parameters.  Review the [API Basics tutorial](API_Basics.md)
- access to a Prisma Cloud tenant
- terminal shell (i.e. bash or zsh)
- install [jq](https://stedolan.github.io/jq/download/)
- familiarity with a [text editor or IDE](../../tools/Text_Editors.md) (i.e. nano, vim, VSCode)
- obtain Values for the following environment variables:

| **Env Variable** | **Value** | **How To Obtain** |
| ------------------ | --------------------- | ---------------- |
| **PC_API_URL** | **'https://<YOUR_TENANT_API_URL>'** | *Visit [Prisma PAN API Docs](https://prisma.pan.dev/api/cloud/api-urls) to map your tenant URL to the tenant API URL.* |
| **PC_ACCESS_KEY** | **'<YOUR_ACCESS_KEY>'** | *Log into Prisma Cloud and go to Settings > Access Keys* |
| **PC_SECRET_KEY** | **'<YOUR_SECRET_KEY>'** | *Obtain your Secret Key at time of Access Key creation.* |
   
   
## 1 - Working with the Prisma Cloud APIs 

We first will determine what we need to login and authenticate with the Prisma Cloud APIs.  For the purposes of this lab tutorial, we will primarily focus on interacting with the CSPM API.  The learning however can applied to both Prisma Cloud APIs (or any other API that uses authentication for that matter).

Since we will focus on the CSPM API, let's refer directly to the [Prisma Cloud Login API Overview Page](https://prisma.pan.dev/api/cloud/cspm/login) as we go through this section.   

You will see that we need two items:
1. An active Access Key with a Secret Key (as mentioned in the prerequistes).
2. Using the Access Key to obtain a JSON Web Token (JWT).

We will use curl with the POST /login request to obtain a JWT.

If you went through the API Basics Lab in this folder, then you may recall there are four(4) parts to an API request.  Let's map them to what we need.   
   
On the Right-Hand side of the [POST /login](https://prisma.pan.dev/api/cloud/cspm/login#operation/app-login) API section, under **Request Samples**, Click **Shell + Curl**

You should see this (I've also added my comments to each line on the right to indicate the relevant API request part):
```
curl --request POST \                                       # The Method
  --url https://api.prismacloud.io/login \                  # The Endpoint
  --header 'content-type: application/json; charset=UTF-8   # The Header
```

Under the same **Request Samples** area on the API doc page, now click the **Payload** section.   
All of the below is `The Data (or body)`:
```
{
  "customerName": "string",
  "password": "string",
  "prismaId": "string",
  "username": "string"
}
```
   
Great, we have the four parts we need for our API request!   
   
Next, we will create a small bash script using environment varaibles to inject our values into the request, **most importantly to keep sensitive clear text data out of our script!**

## 2 - Create Prisma Cloud API Script

Before proceeding, suggest to quicky review [Keeping your secrets out of your Bash History](../secrets-mgmt/Keeping_Secrets_Out_Of_Bash_History.md
) for being mindful in advance for use in production.  

Open your terminal window and export your environment variables.   
   
Replace each `<TEXT>` section below with your values.
```
export PC_API_URL="https://<YOUR_TENANT_API_URL>"
export PC_ACCESS_KEY="<YOUR_ACCESS_KEY>"
export PC_SECRET_KEY="<YOUR_SECRET_KEY>"
```

Create a new project directory and cd into it:
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

Next, we want to insert our `PC_API_URL` environment variable into our endpoint portion of the API request.
Replace this:
```
curl --request POST \
     --url https://api.prismacloud.io/login \
     --header 'content-type: application/json; charset=UTF-8
```
with this:
```
curl --request POST \
     --url "${PC_API_URL}/login" \
     --header 'content-type: application/json; charset=UTF-8
```

Next, we need to define a shell variable for the authentication (data) payload.  Why?  The problem is, bash won't interpret the JSON data correctly if we assigned the raw JSON to a variable. To get around this we'll need to reformat the raw JSON so it's interpreted correctly. 

There's multiple ways to do this and pros and cons to each. 

One way to do this, is by escaping all the quotes inside the json block.  This however can cause headaches for larger blocks of data.  
```
pc_auth_payload="{\"password\": \"${PC_SECRET_KEY}\", \"username\": \"${PC_ACCESS_KEY}\"}"
```

Instead and for simplicity's sake, I'm going to create this shell variable in the script using a [HereDoc](https://linuxize.com/post/bash-heredoc/) in order to pass our multi-line block of JSON data into the variable.   

To do this, we will take our json payload below.  You'll notice I excluded the `"customerName"` and `"prismaId"` fields as they are not required:
```json
{
  "password": "string",
  "username": "string"
}
```
And write that in our script using a HereDoc with:
- the `cat` command
- the use of `<<` as our redirection operator
- the text `JSONDATA` as our delimiter (the text can be anything as long you match it at beginning and end)
- and surrounding the entire thing with `()` to pass it all into our new shell variable `pc_auth_payload`:
```
pc_auth_payload=$(cat <<JSONDATA
{
  "password":"$PC_SECRET_KEY", 
  "username":"$PC_ACCESS_KEY"
}
JSONDATA
)
```

If you don't fully understand what I did here, have a read through one of these articles:
- https://ostechnix.com/bash-heredoc-tutorial/
- https://linuxize.com/post/bash-heredoc/
   
The beautiful thing about this, is we now know how to take any block of JSON data (no matter how long and complex) and stick it right in a HereDoc!  As you work with more complex API endpoints, you will certainly grow to appreciate this.

The last thing we need to do is add the `--data` line to our curl request utilizing our new shell variable `pc_auth_payload`.  
The last line of the curl request therefore will look like this:
```
--data "${pc_auth_payload}"
```

Now we're ready to make our first api call using curl. 

Let's put everyhting together in our script.  It should look like this:

```bash
#!/bin/bash

# Pass JSON data with our environment variables directly as a multi-line string to a shell variable.
pc_auth_payload=$(cat <<JSONDATA
{
  "password":"$PC_SECRET_KEY", 
  "username":"$PC_ACCESS_KEY"
}
JSONDATA
)

# Authenticate to Prisma Cloud to fetch token and filter out only the JSON token data.  Using '-s' to quiet curl command.
curl --request POST \
     --url "${PC_API_URL}/login" \
     --header 'content-type: application/json; charset=UTF-8' \
     --data "${pc_auth_payload}"
```

_Note: the `#` comments out the line in bash. I'll use that to indicate what I'm doing_


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
