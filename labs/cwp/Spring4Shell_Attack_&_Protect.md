# Lab for simulating Spring4Sheel Attack on AWS and Protecting with Prisma Cloud

These set of instructions are written to incorporate several compnonents.  Namely:
- Discuss how we offer Agentless and the Pros & Cons of Agentless only
- The recent Critical Vulnerabilities such as Log4Shell & Spring4Shell and noting there are always yet to be discovered ones
- Why any public facing workloads need Agents & Deploying a Container Defender
- Why WAAS & enabling it

Do all of the following steps in advance of the demo

## Lab Setup
Refer to Internal Spring4Shell Docs at this time until can rewrite for sharing
- Complete all initial setup steps and Steps 1 & 2 of the 'Perform Attack Steps' and before runing the exploit script in Step 3.
- Copy all the commands in the following steps in a notepad and pre-enter the Target-IP address.  This will save time in demo.
- Login to Prisma Cloud and Initiate both:
    - (Optional, noting that we only scan Hosts at this time, so willl only get results for the Host and see error for container) Agentless Scan - Monitor > Vulnerabilities > Host > Scan Agentless
    - (Optional) Cloud Discovery on AWS - Monitor > Compliance > Cloud Discovery > Click on your account/EC2 service line.  Verify the new instances are shown here and as not defended.

## Install Defender
- Refer to [Install Defenders](https://github.com/jjchavanne/cheat-sheets/blob/main/prisma-cloud/Install_Defenders.md)
1. Navigate to your AWS Console > EC2 > Click your **'spring4shell-ubuntu-lab'** instance
2. Click **'Connect'**
3. Copy the SSH command under SSH Client and login into your machine via a terminal session
4. Refer to above directions, install twistci, export variables, and install a container defender
5. Verify in the Console that it recognizes a Defender is now installed on device

## Setup WAAS Rule - REFACTOR
1. Go to Prisma Console (Enterprise Edition ONLY) - **Compute > Defend > WAAS > Host**
2. Click **‘Add Rule’**
3. Rule Name: **Spring4Shell Defense**
4. Then click in the **'Scope'** field
5. Make sure there is a Check box next to **All**.  Alternatively you can create a rule specific for this vulnerable Host.
    - Step 5a: (OPTIONAL) If writing a specifc rule (not All) and there are none for your Host, click **'Add Collection'**, type in a name, Click in the **Host** field, select your vulnerable Host instance, and click **'Save'**
    - Step 5b: Ensure you have your desired collection box checked and click **'Select collections'**
6. Click **‘Add New App’**
7. On the next pop-up click the **‘+ Add Endpoint’**
8. Enter **80** for App port (internal port) then hit **‘Create’**
9. Click the **‘App Firewall'** tab and confirm all settings are set to **Alert**, (with exception to Detect Information Leakage). 
10. Click **‘Save’**

NOTE: For performing the demo, suggest to **'Disable'** the alert temporarily and Allow Prisma Cloud to Discover the 
vuln_app_app container in the Radars view after installing the defender during the demo and that it shows that it is an Unprotected Web App.**. 

## Pre-Demo verification Steps
1. Verify on **Compute > Radars > Container** screen, the new vulnerable container has completed learning mode and shows the red firewall with a line through it, indicating it is an unprotected Web App
    - This make take 10-20 mins after installing the Defender to show up.
2. Verify in **Compute > Monitor > Compliance > Cloud Discovery > Your Credentail/EC2 Service Line** shows the expected number of devices Defended.  The Kali Attacker machine should not be.  Ensure to state this in the demo if you show this.
3. 

## Begin Demo - REFACTOR
1. Navigate to **Compute > Radars > Containers** and click the **vuln_app_app** and **VERIFY THIS AND REFACTOR NOTING THIS MAY NEED TO BE DONE ON THE HOST** highlight that it was recognized as a **Unprotected Web App**
2. Show vulnerabilities and Compliance issue.
3. Click the **Defend** button and Enable the WAAS rule
4. Show that the WAAS is only in Alert mode for now.
5. Run the attack 

### Show the events
1. Navigate to **Compute > Monitor > Events > WAAS for hosts** and scroll to bottom.  Should see events for these attacks.  Discuss both.
    - Code Injection
    - Local File Inclusion
2. Navigate to **Compute > Radars > Hosts** Locate the new Host and should show red hue around.  Click and show that it has been involved in an Incident.
3. Navigate to **Compute > Monitor > Runtime > Incident Explorer** Should see incidents for these attacks.  Discuss both.
    - Reverse Shell
    - Lateral Movement

## Cleanup
1. Disable Host WAAS rule
2. Exit SSH sessions and run the `bash destroy-lab.sh` script
