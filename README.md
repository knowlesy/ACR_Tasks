# Azure Container Repository Scheduled Tasks

This will show you how to get a scheduled azure container  task that will build an image in this particular case just Alpine at a scheduled time and store it in the ACR. This has a variety of benefits for example say if your wanting upgrades to your layers. 

Another option If you have links to base images this could be useful as refence or if your wanting an import you could just use the acr import commands within a pipeline or look at encoded script block. 

This is a lab only !

## Pre-Req's

* terraform installed locally
* VSCode with TF Extension and Git
* AZ Cli or AZ PS Module 
* Azure Environment 
* Github account with PAT Token


## Instructions

Git clone in VS Code and modify the cron job to a more specific time closer to you, remember this will be executed in UTC Time. The following can help [crontab guru](https://crontab.guru/)

in your terminal cd into the TF folder then run through following prompts 

Log in to azure [AZ CLI](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli) or [Powershell](https://learn.microsoft.com/en-us/powershell/azure/authenticate-azureps?view=azps-10.1.0)

    az login --t "XYZ"

Initialize TF Code

    terraform init -upgrade

Plan TF Code have your pat token ready [help on pat tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)

You could also switch the github link to a storage account and SAS token as an alternative. 

    terraform plan -out main.tfplan

You will be prompted for your token 

![image](https://github.com/knowlesy/ACR_Tasks/assets/20459678/d2ddeefe-27f5-4efa-b6b1-579f6ff07fd3)

NOTE: This isnt stored securely as this is a LAB!

Apply TF Code

    terraform apply main.tfplan

Any of the code below will rely on the following variable run this after your tf apply

     $registry = (terraform output -raw acr_login).replace(".azurecr.io","")

Your Key vault and Azure Container Registry will be created 

![image](https://github.com/knowlesy/ACR_Tasks/assets/20459678/90383577-af20-4ea2-8658-bca50223689e)

Check your tasks 

![image](https://github.com/knowlesy/ACR_Tasks/assets/20459678/563ce869-5cd3-467d-a362-5539a4dc6c67)

Or Run the following 

    az acr task show -n daily-pull-task -r $registry -o table

![image](https://github.com/knowlesy/ACR_Tasks/assets/20459678/4f15a6b0-8db4-43b3-bfcd-5ed6ac08f3af)

Some additional scripts to run and brows your repository

    #lists the timer for the task (if applicable
	az acr task timer list -n daily-pull-task -r $registry

    #forces the task manually	  
    az acr task run -n daily-pull-task -r $registry
  
    #Shows Logs 
    az acr task logs -r $registry
    #Lists runs executed 
    az acr task list-runs -r $registry -o table
    az acr repository list --name  $registry --output table
  
    #By tag name  
    az acr repository show-tags -n $registry --repository alpine --orderby time_desc --output table

Repositorys

![image](https://github.com/knowlesy/ACR_Tasks/assets/20459678/7dd05570-85e8-445a-a12b-529b96cade13)


Tear down the env 

    terraform plan -destroy -out main.destroy.tfplan
    terraform apply "main.destroy.tfplan"

References below have helped in making this example 
* [How to consume and maintain public content with Azure Container Registry Tasks](https://learn.microsoft.com/en-us/azure/container-registry/tasks-consume-public-content)
* [Automate container image builds and maintenance with ACR Tasks](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-tasks-overview)
* [Consuming Public Content](https://opencontainers.org/posts/blog/2020-10-30-consuming-public-content/)
* [Manage public content with Azure Container Registry](https://learn.microsoft.com/en-us/azure/container-registry/buffer-gate-public-content?tabs=azure-cli)
* [Tutorial: Automate container image builds when a base image is updated in another private container registry](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-tutorial-private-base-image-update)
* [azurerm_container_registry_task](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry_task)
* [Deploy Container App and pull image from Azure Container Registry using Terraform and AzAPI](https://thomasthornton.cloud/2022/12/15/deploy-container-app-and-pull-image-from-azure-container-registry-using-terraform-and-azapi/)
* [Docker Hub Account](https://docs.docker.com/docker-hub/download-rate-limit/#how-do-i-authenticate-pull-requests)
* [Docker API Tokens](https://docs.docker.com/docker-hub/access-tokens/)
* [ACR Sku's](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-skus)
* [ACR Import Container Images](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-import-images?tabs=azure-cli)
  
