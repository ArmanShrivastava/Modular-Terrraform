output "nsg_ids" {
  description = "Map of network security group IDs keyed by logical name."
  value       = { for key, nsg in azurerm_network_security_group.this : key => nsg.id }
}

output "nsg_names" {
  description = "Map of network security group names keyed by logical name."
  value       = { for key, nsg in azurerm_network_security_group.this : key => nsg.name }
}

output "inbound_rule_ids" {
  description = "Map of inbound rule IDs keyed by resource address."
  value       = { for rule_key, rule in azurerm_network_security_rule.inbound : rule_key => rule.id }
}

output "outbound_rule_ids" {
  description = "Map of outbound rule IDs keyed by resource address."
  value       = { for rule_key, rule in azurerm_network_security_rule.outbound : rule_key => rule.id }
}
