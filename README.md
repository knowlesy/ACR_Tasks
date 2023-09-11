# ADO Pipeline to Create a Container image
Azure Devops Container Build Pipeline

ADO = Azure Devops

This is a lab only !

## Pre-Req's

* Azure Devops Organization and Project for testing
* terraform installed locally
* VSCode with TF Extension and Git
* AZ Cli or AZ PS Module 
* Azure Environment 
* Docker Hub account and API token 
* Azure Service Principle created  and set up in Azure devops [guide](https://learn.microsoft.com/en-us/azure/devops/integrate/get-started/authentication/service-principal-managed-identity?view=azure-devops) , [alt guide](https://learn.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli)

## Instructions

Git clone in VS Code and cd into the TF folder then run through the motions

Import the repo into your test project in ADO





In your VSCode Terminal 

Log in to azure [AZ CLI](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli) or [Powershell](https://learn.microsoft.com/en-us/powershell/azure/authenticate-azureps?view=azps-10.1.0)

Initialize TF Code

    terraform init -upgrade

Plan TF Code

    terraform plan -out main.tfplan

Apply TF Code

    terraform apply main.tfplan


Once this has run add your SPN as a contributor to the ACR

In ADO under your project go to project settings > service connections > new service connection > docker registry > next

Click Azure Container Reg... set to Service Principle Click Add 








In Azure portal or via your connection to Azure run thr following AZ Cli command to see the images stored in the repository

    az acr repository list --name <acrName> --output table

To get a list of the versions run the following substituting reponame for your image name / build shown in the previous step

    az acr repository show-tags -n <RegistryName> --repository <reponame> --orderby time_desc --output table


DESTROY!!!!!!!!!!!!!

    terraform plan -destroy -out main.destroy.tfplan
    terraform apply "main.destroy.tfplan"

References below have helped in making this example 
* [TF Azure Container Registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry)
* [Microsoft PS Container](https://hub.docker.com/_/microsoft-powershell)
* [Azure Container Registry Tiers](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-skus)
* [Building in ADO](https://learn.microsoft.com/en-us/azure/devops/pipelines/ecosystems/containers/build-image?view=azure-devops)
* [Docker task commands](https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/reference/docker-v2?view=azure-pipelines&tabs=yaml)
* [ADO Service Connections](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml#docker-registry-service-connection)
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