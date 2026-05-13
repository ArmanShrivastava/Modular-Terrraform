# Azure Network Security Groups Module
# Manages NSGs and their associated inbound/outbound rules

# Temporarily commented out for_each to enable import
# resource "azurerm_network_security_group" "this" {
#   for_each = var.network_security_groups

#   name                = each.value.name
#   location            = var.location
#   resource_group_name = var.resource_group_name

#   tags = merge(
#     var.tags,
#     try(each.value.additional_tags, {})
#   )
# }

# Temporary individual NSG resources for import
resource "azurerm_network_security_group" "appgw_nsg" {
  name                = "appgw-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_group" "jumpbox_nsg" {
  name                = "jumpbox-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_group" "aks_nsg" {
  name                = "aks-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_group" "private_endpoints_nsg" {
  name                = "private-endpoints-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_network_security_group" "ado_agent_nsg" {
  name                = "ado-agent-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

# Inbound rules
resource "azurerm_network_security_rule" "inbound" {
  for_each = {
    for rule_key, rule_config in flatten([
      for nsg_key, nsg_config in var.network_security_groups : [
        for rule_idx, rule in try(nsg_config.inbound_rules, []) : {
          key           = "${nsg_key}-in-${rule_idx}"
          nsg_key       = nsg_key
          nsg_name      = nsg_config.name
          rule          = rule
          priority      = try(rule.priority, 100 + rule_idx)
        }
      ]
    ]) : rule_key => rule_config
  }

  name                        = each.value.rule.name
  priority                    = each.value.priority
  direction                   = "Inbound"
  access                      = each.value.rule.access
  protocol                    = each.value.rule.protocol
  source_port_range           = try(each.value.rule.source_port_range, "*")
  destination_port_range      = try(each.value.rule.destination_port_range, "*")
  source_port_ranges          = try(each.value.rule.source_port_ranges, null)
  destination_port_ranges     = try(each.value.rule.destination_port_ranges, null)
  source_address_prefix       = try(each.value.rule.source_address_prefix, null)
  source_address_prefixes     = try(each.value.rule.source_address_prefixes, null)
  destination_address_prefix  = try(each.value.rule.destination_address_prefix, "*")
  destination_address_prefixes = try(each.value.rule.destination_address_prefixes, null)

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this[each.value.nsg_key].name
}

# Outbound rules
resource "azurerm_network_security_rule" "outbound" {
  for_each = {
    for rule_key, rule_config in flatten([
      for nsg_key, nsg_config in var.network_security_groups : [
        for rule_idx, rule in try(nsg_config.outbound_rules, []) : {
          key           = "${nsg_key}-out-${rule_idx}"
          nsg_key       = nsg_key
          nsg_name      = nsg_config.name
          rule          = rule
          priority      = try(rule.priority, 100 + rule_idx)
        }
      ]
    ]) : rule_key => rule_config
  }

  name                        = each.value.rule.name
  priority                    = each.value.priority
  direction                   = "Outbound"
  access                      = each.value.rule.access
  protocol                    = each.value.rule.protocol
  source_port_range           = try(each.value.rule.source_port_range, "*")
  destination_port_range      = try(each.value.rule.destination_port_range, "*")
  source_port_ranges          = try(each.value.rule.source_port_ranges, null)
  destination_port_ranges     = try(each.value.rule.destination_port_ranges, null)
  source_address_prefix       = try(each.value.rule.source_address_prefix, "*")
  source_address_prefixes     = try(each.value.rule.source_address_prefixes, null)
  destination_address_prefix  = try(each.value.rule.destination_address_prefix, null)
  destination_address_prefixes = try(each.value.rule.destination_address_prefixes, null)

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this[each.value.nsg_key].name
}
