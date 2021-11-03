# Rest API Basics & cURL 101

## Brief Intro on cURL

Before we dive into interacting with Prisma Cloud, let's cover some basics on cURL

Run the curl command on your github profile:
> **Example:**
```
curl https://api.github.com/users/jjchavanne
```
> **You should receive something back like this, noting that I've ommited some lines for brevity.**
```
{
  "login": "jjchavanne",
  "id": 31355989,
  "node_id": "MDQ6VXNlcjMxMzU1OTg5",
  "avatar_url": "https://avatars.githubusercontent.com/u/31355989?v=4",
  "gravatar_id": "",
  "url": "https://api.github.com/users/jjchavanne",
  "html_url": "https://github.com/jjchavanne",
  "followers_url": "https://api.github.com/users/jjchavanne/followers",
  ...
}
   
If you paste the same API URL (without 'curl ') into a browser window you will get the same results.
   
Now try to hit your Prisma Cloud API 
> **Example:**
```
curl 	https://api.prismacloud.io
```
   
You should receive a 404 Not Found error.  This is expected.  Why?

Unlike your Github user profile that is available to the public, the Prisma Cloud tenants are not.  They are private and they require authentication.
   
