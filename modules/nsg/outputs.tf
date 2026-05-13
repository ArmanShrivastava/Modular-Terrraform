output "nsg_ids" {
  value = {
    appgw-nsg = azurerm_network_security_group.appgw_nsg.id
    jumpbox-nsg = azurerm_network_security_group.jumpbox_nsg.id
    aks-nsg = azurerm_network_security_group.aks_nsg.id
    private-endpoints-nsg = azurerm_network_security_group.private_endpoints_nsg.id
    ado-agent-nsg = azurerm_network_security_group.ado_agent_nsg.id
  }
  description = "Map of Network Security Group IDs"
}

output "nsg_names" {
  value = {
    appgw-nsg = azurerm_network_security_group.appgw_nsg.name
    jumpbox-nsg = azurerm_network_security_group.jumpbox_nsg.name
    aks-nsg = azurerm_network_security_group.aks_nsg.name
    private-endpoints-nsg = azurerm_network_security_group.private_endpoints_nsg.name
    ado-agent-nsg = azurerm_network_security_group.ado_agent_nsg.name
  }
  description = "Map of Network Security Group names"
}

output "inbound_rule_ids" {
  value = {
    for rule_key, rule in azurerm_network_security_rule.inbound : rule_key => rule.id
  }
  description = "Map of inbound rule IDs"
}

output "outbound_rule_ids" {
  value = {
    for rule_key, rule in azurerm_network_security_rule.outbound : rule_key => rule.id
  }
  description = "Map of outbound rule IDs"
}
