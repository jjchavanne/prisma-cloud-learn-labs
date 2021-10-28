# Using Hashicorp Vault in Dev Mode for Secrets Management

This tutorial follows the [Hashicorp Learn Vault Tutorials](https://learn.hashicorp.com/collections/vault/getting-started).  Our tutorial below only covers brief portions of the first 4 tutorials mentioned in the Vault CLI Quick Start section.  Visit the link above to run through all the tutorials in detail.

## What you'll need:
- terminal shell (i.e. bash or zsh)
- install [Vault](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started)

## Setup Vault Dev Server
With Vault installed, start the dev server:
```
vault server -dev
```

Launch a new terminal window.
   
Copy the `export VAULT_ADDR ...` command from the first terminal output and run in the second terminal window.  
**Example:**
```
export VAULT_ADDR='http://127.0.0.1:8200'
```
Save the unseal key somewhere. Don't worry about how to save this securely. For now, just save it anywhere.

Set the `VAULT_TOKEN` environment variable value to the generated **Root Token** value displayed in the terminal output.   
**Example:**
```
export VAULT_TOKEN="s.XmpNPoi9sRhYtdKHaQhkHP6x"
```
To verify the server is running:
```
vault status
```

## Writing a Secret

To write a secret, use the `vault kv put secret/<SECRET_NAME> <KEY_NAME>=<VALUE>` command.  
   
Example of a secret with a single key/value pair:
```
vault kv put secret/myapp password=S3cure-P@ssw0rd!
```

Example with mutiple key/value pairs:
```
vault kv put secret/myapp \
    access_key=My-Access-Key \
    secret_key=S3cure-K3y!
```

## Getting a Secret

Use the command `vault kv get <PATH>`
  
Example:
```
vault kv put secret/myapp
```
  
This is enough to get started with and is all we are going to cover for now.  As mentioned at the top of this page, visit [Hashicorp Learn Vault Tutorials](https://learn.hashicorp.com/collections/vault/getting-started) for more in depth learning of Vault.
  
