variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}
variable "resource_group_location" {
  type        = string
  default     = "uksouth"
  description = "Location of the resource group."
}

# variable "docker_username" {
#   description = "Docker Username"
#   type = string 
# }

# variable "docker_password" {
#   description = "Docker Password"
#   type = string 
# }

variable "github_token" {
  description = "GitHub Token"
  type = string 
}