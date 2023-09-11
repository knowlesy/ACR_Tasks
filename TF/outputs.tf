output "acr_id" {
  value = azurerm_container_registry.acr.id
}

output "acr_login" {
  value = azurerm_container_registry.acr.login_server
}

output "github_token" {
  value = var.github_token
}