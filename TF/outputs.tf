output "acr_id" {
  value = azurerm_container_registry.acr.id
}

output "acr_login" {
  value = azurerm_container_registry.acr.login_server
}

# output "docker_usr" {
#   value = var.docker_username
# }

# output "docker_pas" {
#   value = var.docker_password
# }

output "github_token" {
  value = var.github_token
}