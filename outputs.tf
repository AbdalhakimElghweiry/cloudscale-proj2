output "resource_group_name" {
  description = "Name of the Azure Resource Group"
  value       = azurerm_resource_group.main.name
}

output "container_ip_address" {
  description = "Public IP address of the container"
  value       = azurerm_container_group.main.ip_address
}

output "container_fqdn" {
  description = "Fully qualified domain name of the container"
  value       = azurerm_container_group.main.fqdn
}

output "app_url" {
  description = "URL to access the web application"
  value       = "http://${azurerm_container_group.main.fqdn}"
}