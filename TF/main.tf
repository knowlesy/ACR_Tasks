#brings in some data from your Az login session
data "azurerm_client_config" "current" {}
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}
#creates RG
resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

resource "random_string" "azurerm_sa_name" {
  length  = 10
  lower   = true
  numeric = true
  special = false
  upper   = false
}


resource "azurerm_container_registry" "acr" {
  name                = coalesce("cr${random_string.azurerm_sa_name.result}")
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false

}

#creates a random string to append to keyvault name so it is unique
resource "random_string" "azurerm_key_vault_name" {
  length  = 13
  lower   = true
  numeric = false
  special = false
  upper   = false
}
#Creates Key vault and assigns access policy via conditional policies to the user running this
resource "azurerm_key_vault" "vault" {
  name                       = coalesce("vault-${random_string.azurerm_key_vault_name.result}")
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7
  access_policy {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = data.azurerm_client_config.current.object_id
    secret_permissions = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
  }
}

# resource "azurerm_key_vault_secret" "docker_pas" {
#   name         = "dockerPassword"
#   value        = var.docker_password
#   key_vault_id = azurerm_key_vault.vault.id
#   depends_on   = [azurerm_key_vault.vault]
# }

# resource "azurerm_key_vault_secret" "docker_usr" {
#   name         = "dockerUser"
#   value        = var.docker_username
#   key_vault_id = azurerm_key_vault.vault.id
#   depends_on   = [azurerm_key_vault.vault]
# }

resource "azurerm_key_vault_secret" "github_token" {
  name         = "githubtoken"
  value        = var.github_token
  key_vault_id = azurerm_key_vault.vault.id
  depends_on   = [azurerm_key_vault.vault]
}

resource "azurerm_container_registry_task" "acr" {
  name                  = "daily-pull-task"
  container_registry_id = azurerm_container_registry.acr.id
  platform {
    os = "Linux"
  }
  docker_step {
    dockerfile_path      = "Dockerfile"
    context_path         = "https://github.com/knowlesy/ACR_Tasks.git"
    context_access_token = azurerm_key_vault_secret.github_token.value
    image_names          = ["alpine:{{.Run.ID}}"]
  }
  #UTC Time! 
  timer_trigger{
    schedule = "20 21 * * *"
    name = "daily-pull-task"
  }
}
