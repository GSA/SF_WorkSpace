# This README provides instructions to use the Salesforce CLI & Git CLI with few basic commands

### Git CLI
- [Clone the Workspace Repo](#clone-the-workspace-repo)
- [Commit & Push the Workspace Repo](#commit--push-the-workspace-repo)
- [List branches](#list-branches)
- [Checkout a branch](#checkout-a-branch)
- [Get the latest code](#update-the-source-with-latest)

### SF CLI
- [Login to a Salesforce Instance](#login-to-org)
- [List Authorized Orgs](#list-authorized-orgs)
- [Display Org Information](#display-org-information)
- [Retrieve Metadata from Org](#retrieve-metadata-from-org)
- [Deploy Metadata to Org](#deploy-metadata-to-org)

### Further Reading
- [References](#read-all-about-it)
### Release Process Guide
- [SF CLI](https://docs.google.com/document/d/1hj45R8sqNfNQMLhSzQmPMeBe_OHwZJsSr9Mv5gNn14U)
- [VSCODE](https://docs.google.com/document/d/1yK5HpOex_9rnBS1rIqC2dXMqZ3QgWVgEsV_nVUOVeIU)

## Login to Org

To log in to a Salesforce org via a web browser and set an alias for the org.

### Command Syntax

```bash
sf org login web --alias <ORG_ALIAS>
```

### Command Overview

This command allows you to log in to a Salesforce org through the Salesforce CLI and assign an alias name for easier reference in future commands.

After running this command, a web browser window will open, prompting you to log in to your Salesforce org.
Once logged in, the CLI saves this org connection locally with the specified alias.

------------------------------------------------------------------------------------------------------------------------

## List Authorized Orgs

To display all Salesforce orgs you are currently authenticated to.

### Command Syntax

```bash
sf org list
```

### Command Overview

This command helps you to view a list of all authorized Salesforce orgs along with useful details such as aliases, usernames, and expiration dates for scratch orgs. This is helpful for managing multiple orgs and verifying your current authenticated sessions.


------------------------------------------------------------------------------------------------------------------------

## Display Org Information

To view the detailed information about a specific Salesforce org.

### Command Syntax

```bash
sf org display --target-org <ORG_ALIAS>
```

### Command Overview

This command retrieves and displays detailed information about a Salesforce org you are authenticated to, including org ID, instance URL, access token, and more. This is useful for verifying your connection details and debugging issues.


------------------------------------------------------------------------------------------------------------------------

## Retrieve Metadata from Org

To retrieve metadata from a Salesforce org based on a manifest file (`package.xml`). Use **packages/release_package.xml** to retrieve release specific artifacts.

### Command Syntax

```bash
sf project retrieve start --manifest <PATH_TO_PACKAGE.XML> --target-org <ORG_ALIAS>
```

### Command Overview

This command retrieves metadata from a specified Salesforce org using a manifest file (`package.xml`). This is often used in development workflows to pull metadata into your local project directory, making it easier to work with configuration and customizations.



------------------------------------------------------------------------------------------------------------------------

## Deploy Metadata to Org

To deploy metadata to a Salesforce org using a manifest file (`package.xml`). Use **packages/release_package.xml** to deploy release specific artifacts.

### Command Syntax

```bash
sf project deploy start --manifest <PATH_TO_PACKAGE.XML> --target-org <ORG_ALIAS>
```

### Command Overview

This command deploys metadata to a specified Salesforce org based on the contents of a manifest file (`package.xml`). This command is commonly used in development and deployment workflows to push specific configurations and customizations to an org.

------------------------------------------------------------------------------------------------------------------------

## Clone the Workspace Repo

To clone the Workspace Repo

### Command Syntax

```bash
git clone https://github.com/GSA/Sf_WorkSpace.git
```

### Command Overview

This command clones the Workspace repository to your workstation. 

Refer to the following document to know more about authenticating to github via https or ssh.

https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/about-authentication-to-github#authenticating-with-the-command-line

------------------------------------------------------------------------------------------------------------------------

## Commit & Push the Workspace Repo

To commit the source code to Github repository after making changes. Make sure you are on the root of the project, 

### Command Syntax

```bash
git add . 
git commit -m "Your comment about the commit"
git push <remote name> <branch name> 

eg. git push origin main 
```

### Command Overview

This set of commands push your changes to Github repository

------------------------------------------------------------------------------------------------------------------------

## List branches

To list the branch names with remote names

### Command Syntax

```bash
git branch -r
```

### Command Overview

This command list the branch names with remote names. Example output given below:

```
origin/HEAD -> origin/main
origin/main
```
------------------------------------------------------------------------------------------------------------------------

## Checkout a branch

To fetch all branches and checkout a specific branch

### Command Syntax

```bash
git fetch
git checkout <branch name>
```

### Command Overview

This set of commands fetch all the branches in the repository and checks out the specified branch. 

------------------------------------------------------------------------------------------------------------------------

## Update the source with latest

To update the source with the latest code

### Command Syntax

```bash
git pull

or

git pull <remote name> <branch name>
```

### Command Overview

This command retrieves the latest code from the Github repository 

------------------------------------------------------------------------------------------------------------------------

## Read All About It
- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
- [Commonly used Git commands](https://github.com/joshnh/Git-Commands)
