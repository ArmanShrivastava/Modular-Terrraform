resource "azurerm_container_registry" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  tags                = var.tags

  public_network_access_enabled = var.public_network_access_enabled
  anonymous_pull_enabled        = var.anonymous_pull_enabled
  data_endpoint_enabled         = var.data_endpoint_enabled

  dynamic "retention_policy" {
    for_each = var.retention_policy_enabled ? [1] : []

    content {
      days    = var.retention_policy_days
      enabled = true
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
