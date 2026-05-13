output "id" {
  value       = azurerm_application_gateway.this.id
  description = "Application Gateway ID"
}

output "name" {
  value       = azurerm_application_gateway.this.name
  description = "Application Gateway name"
}

output "frontend_ip_configuration" {
  value       = azurerm_application_gateway.this.frontend_ip_configuration
  description = "Frontend IP configuration details"
}

output "backend_address_pools" {
  value       = azurerm_application_gateway.this.backend_address_pool
  description = "Backend address pools"
}
