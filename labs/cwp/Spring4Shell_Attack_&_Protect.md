# Lab for simulating Spring4Sheel Attack on AWS and Protecting with Prisma Cloud

Do all of the following steps in advance 
## Lab Setup
Refer to Internal Spring4Shell Docs at this time until can rewrite for sharing

## Install Defender
Install a Container Defender on the Vulnerable machine
- Follow [Install Defenders](https://github.com/jjchavanne/cheat-sheets/blob/main/prisma-cloud/Install_Defenders.md)

## Setup WAAS Rule
1. Go to Prisma Console (Enterprise Edition ONLY) - **Compute > Defend > WAAS**
2. Click **‘Add Rule’**
3. Rule Name: **Spring4Shell Defense**
4. Then click in the **'Scope'** field
5. Check boxes of all images that have **vuln_app_app** in them.
    - Step 5a: If there are none, click **'Add Collection'**, type in a name, type in **vuln_app** in the image field, select the image(s), and click **'Save'**
    - Step 5b: Ensure you have the **vuln_app** boxes checked and click **'Select collections'**
6. Click **‘Add New App’**
7. On the next pop-up click the **‘+ Add Endpoint’**
8. Enter **80** for App port (internal port) then hit **‘Create’**
9. Click the **‘App Firewall'** tab and confirm all settings are set to **Alert**, (with exception to Detect Information Leakage). 
10. Click **‘Save’**

**For performing the demo, suggest to 'Disable' the alert temporarily and Allow Prisma Cloud to Discover the 
vuln_app container in the Radars view and that it shows that it is an Unprotected Web App.**. 

## Begin Demo
1. Navigate to **Compute > Radars > Containers** and click the **vuln_app_app** and highlight that it was recognized as a **Unprotected Web App**
2. Show vulnerabilities and Compliance issue.
3. Click the **Defend** button and Enable the WAAS rule
4. Show that the WAAS is only in Alert mode for now.
5. Run the attack 
