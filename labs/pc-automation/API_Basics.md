# Rest API Basics & curl 101

TODO: Build Table of Contents here

## What is a REST API?

TODO: Add info here.



## What is curl?

Before we dive into interacting with Prisma Cloud, let's cover some basics on curl

**curl** is a tool for transfering data from or to a server. It supports many protocols.  Most importantly for us, HTTP & HTTPS. The command is designed to work without user interaction.

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
```
   
If you paste the same API URL (without 'curl ') into a browser window you will get the same results.
   
Now try to hit your Prisma Cloud API 
> **Example:**
```
curl 	https://api.prismacloud.io
```
   
You should receive a 404 Not Found error.  This is expected.  Why?

Unlike your Github user profile that is available to the public, the Prisma Cloud tenants are private.  They require authentication (we'll dive into that in the next lab!).
   
###  cURL Command Options

Info in this section is all taken directly from the [cURL MAN pages](https://curl.se/docs/manpage.html) (Manual).

#### Command Options Explained

Options start with one or two dashes. Many of the options require an additional value next to them.

The short "single-dash" form of the options, -d for example, may be used with or without a space between it and its value, although a space is a recommended separator. The long "double-dash" form, -d, --data for example, requires a space between it and its value.

Short version options that don't need any additional values can be used immediately next to each other, like for example you can specify all the options -O, -L and -v at once as -OLv.

#### Common and important command options.

| **Option** | **Description** |
| ------------------------ | -------------- | 
| **-X** or **--request** | Specifies a custom request method to use when communicating with the HTTP server. |
| **-d** or **--data** | Sends data in a POST request to the HTTP server, same as submitting data in a web form. |
| 



Continue to explore the MAN pages for lots more detail and master ever command option there is.... or not.... 


### Progress Meter

curl normally displays a progress meter during operations, indicating the amount of transferred data, transfer speeds and estimated time left, etc. The progress meter displays number of bytes and the speeds are in bytes per second. The suffixes (k, M, G, T, P) are 1024 based. For example 1k is 1024 bytes. 1M is 1048576 bytes.

curl displays this data to the terminal by default, so if you invoke curl to do an operation and it is about to write data to the terminal, it disables the progress meter as otherwise it would mess up the output mixing progress meter and response data.

If you want a progress meter for HTTP POST or PUT requests, you need to redirect the response output to a file, using shell redirect (>), -o, --output or similar.

This does not apply to FTP upload as that operation does not spit out any response data to the terminal.

If you prefer a progress "bar" instead of the regular meter, -#, --progre
