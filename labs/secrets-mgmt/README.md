# Secrets Management Labs

A list of Secretes Managment labs/tutorials.  This is by no means an exhaustive list.  There are many options out there today.

## Secrets Managment Overview

Secrets management is a critical component of keeping pieces of sensitive data (secrets) you use to authenticate to other applications and systems (i.e Passwords, Access Keys, API Keys, etc.) safe.  Secrets Management helps mitigate the risks of exposure to these secrets, both in transit and at rest.

## Objectives

- Demonstrate foundational secrets management knowledge
- Demonstrate several approaches to managing your secrets

## Methods and Labs/Tutorials Covered Here:

**Plain-Text**
- Storing secrets in plain-text.  Just don't do it.
- Highlighting the danger of systems that may *'by default'* keep your secrets stored in plain-text.
   
**Environment Variables**
- Environment variables passed directly via shell 
- Read from a file
- Additional options to not save in bash history
   
**Encrypted Files**
- Not covered at this time
   
**Secret Stores**
- Hashicorp Vault in Dev Mode


## Additional Reading:

- https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1#bebe
- https://www.beyondtrust.com/blog/entry/secrets-management-overview-7-best-practices 
- https://www.csoonline.com/article/3624577/securing-cicd-pipelines-6-best-practices.html
- https://docs.aws.amazon.com/secretsmanager/latest/userguide/best-practices.html
   
