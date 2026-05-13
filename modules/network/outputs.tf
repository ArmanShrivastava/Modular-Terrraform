output "id" {
  description = "Virtual network resource ID."
  value       = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  description = "Map of subnet IDs keyed by subnet name."
  value       = { for key, subnet in azurerm_subnet.this : key => subnet.id }
}
