#!/bin/bash

# Ensure to load env variables before running script
# API_ENDPOINT_SUFFIX is for the API Endpoint you are sending a request.  See CSPM API Docs: https://prisma.pan.dev/api/cloud/cspm/cspm-api
# Example from: https://prisma.pan.dev/api/cloud/cspm/settings#operation/get-enterprise-settings would be: "settings/enterprise"
# export API_ENDPOINT_SUFFIX="<URL_SUFFIX_FROM API_DOCS>" 

# Additional ref with using Vault to store secrets: https://github.com/Kyle9021/panw-partner-wiki/edit/main/contents/labs/Prisma_Cloud_Enterprise_API_Tutorial.md

pcee_API_URL=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.pcee_api_url)
pcee_ACCESS_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.pcee_accesskey)
pcee_SECRET_KEY=$(vault kv get -format=json secret/prisma_enterprise_env | jq -r .data.data.pcee_secretkey)

pcee_AUTH_PAYLOAD="{\"password\": \"$pcee_SECRET_KEY\", \"username\": \"$pcee_ACCESS_KEY\"}"

# NOTICE THE -s I've added to this call. This quiets the command

pcee_AUTH_TOKEN=$(curl -s --request POST \
                          --url "${pcee_API_URL}/login" \
                          --header 'content-type: application/json; charset=UTF-8' \
                          --data "${pcee_AUTH_PAYLOAD}" | jq -r '.token')

# HERE'S OUR MODIFIED REQUEST with an added -s 

curl -s --request GET \
        --url "${pcee_API_URL}/${API_ENDPOINT_SUFFIX}" \
        --header "x-redlock-auth: ${pcee_AUTH_TOKEN}"
