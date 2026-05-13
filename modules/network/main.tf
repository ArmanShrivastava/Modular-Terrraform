resource "azurerm_virtual_network" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  tags                = var.tags

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan_id == null ? [] : [1]

    content {
      id     = var.ddos_protection_plan_id
      enable = true
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_subnet" "appgw_subnet" {
  name                              = "appgw-subnet"
  resource_group_name               = var.resource_group_name
  virtual_network_name              = azurerm_virtual_network.this.name
  address_prefixes                  = ["10.0.1.0/24"]
  service_endpoints                 = []
  private_endpoint_network_policies = "Enabled"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_subnet" "jumpbox_subnet" {
  name                              = "jumpbox-subnet"
  resource_group_name               = var.resource_group_name
  virtual_network_name              = azurerm_virtual_network.this.name
  address_prefixes                  = ["10.0.5.0/26"]
  service_endpoints                 = []
  private_endpoint_network_policies = "Enabled"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_subnet" "aks_subnet" {
  name                              = "aks-subnet"
  resource_group_name               = var.resource_group_name
  virtual_network_name              = azurerm_virtual_network.this.name
  address_prefixes                  = ["10.0.2.0/23"]
  service_endpoints                 = ["Microsoft.Sql"]
  private_endpoint_network_policies = "Enabled"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_subnet" "private_endpoints_subnet" {
  name                              = "private-endpoints-subnet"
  resource_group_name               = var.resource_group_name
  virtual_network_name              = azurerm_virtual_network.this.name
  address_prefixes                  = ["10.0.4.0/24"]
  service_endpoints                 = ["Microsoft.Sql"]
  private_endpoint_network_policies = "Disabled"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_subnet" "ado_agents_subnet" {
  name                              = "ado-agents-subnet"
  resource_group_name               = var.resource_group_name
  virtual_network_name              = azurerm_virtual_network.this.name
  address_prefixes                  = ["10.0.20.0/24"]
  service_endpoints                 = []
  private_endpoint_network_policies = "Disabled"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = {
    for name, subnet in var.subnets : name => subnet
    if try(subnet.network_security_group_id, null) != null
  }

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value.network_security_group_id
}

resource "azurerm_virtual_network_peering" "this" {
  for_each = var.peerings

  name                         = each.key
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.this.name
  remote_virtual_network_id    = each.value.remote_virtual_network_id
  allow_virtual_network_access = try(each.value.allow_virtual_network_access, true)
  allow_forwarded_traffic      = try(each.value.allow_forwarded_traffic, false)
  allow_gateway_transit        = try(each.value.allow_gateway_transit, false)
  use_remote_gateways          = try(each.value.use_remote_gateways, false)

  lifecycle {
    prevent_destroy = true
  }
}
