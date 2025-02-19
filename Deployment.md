### Release Folder
- [Release Drive Folder](https://www.gsa.gov/)


### Deployment ticket details 
1) High-level summary of changes being made; 

<Jira ticket/story ID>   <Jira title/description>
<org/office> Sprint <# of sprint> for scheduled release to Production on:  <mm-dd-yyyy> 

2) All supporting documentation, as applicable (need links) (Design doc (TDD), Test Cases doc, Deployment Plan, etc..)

    TDD: (https://www.gsa.gov) ensure that you can access/click into successfully, and is for the same App as the ServiceNow ticket, and is NOT a draft or prior year version. ONLY REQUIRED IF CHANGES TO THE DOCUMENT WERE REQUIRED TO BE MADE. If missing also ask submitter if they updated TDD when you ask them to provide the link.
   
    Deployment Plan:   (https://docs.google.com/document/d/1QjkK-anBPDvEy1HUGqm8izag28RZRKyXZNW9CS1a6GY/edit?tab=t.0/) <MUST BE ATTACHED TO RITM, check to see if packages exist on plan and if so check steps 3-5 below>
    Test Cases: <MUST BE ATTACHED TO RITM, ensure that you can access/click into successfully, and that show all test cases passed.
	
4) Code coverage showing 90% or greater; 
<if deployment plan has package, screenshots of this MUST BE ATTACHED TO RITM, confirm the images do show above 90%>

5) Clean code scan on Dev box; 
<if deployment plan has package, needs to have a Fortify Scan ATTACHED TO RITM, do NOT include the link to it.Confirm no critical, high, or medium vulnerabilities on the attachment.

6) Provide confirmation on fully-tested Deployment Plan
<if deployment plan has package, screenshots of this MUST BE ATTACHED TO RITM, confirm the images is a black and white screen saying ‘Deployment Successful’

7) Provide confirmation on fully-tested data migration (if applicable)

8) Identify any New, Updated or Deleted privileges (permission set(s), public group(s), role(s), profile(s), etc.) created along with any users' names and email addresses being assigned.
NOTE: Make sure that the Label, not the API name, is included here under step 7. One way to know if they correctly put the label instead of the API name is that there would be no underscores ( _ ) in a label.
