output "id" {
  description = "Virtual network resource ID."
  value       = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  description = "Subnet IDs keyed by subnet name."
  value = {
    "appgw-subnet"             = azurerm_subnet.appgw_subnet.id
    "jumpbox-subnet"           = azurerm_subnet.jumpbox_subnet.id
    "aks-subnet"               = azurerm_subnet.aks_subnet.id
    "private-endpoints-subnet" = azurerm_subnet.private_endpoints_subnet.id
    "ado-agents-subnet"        = azurerm_subnet.ado_agents_subnet.id
  }
}
