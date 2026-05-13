resource "azurerm_key_vault" "this" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  tenant_id                       = var.tenant_id
  sku_name                        = var.sku_name
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization
  public_network_access_enabled   = var.public_network_access_enabled
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  tags                            = var.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_key_vault_secret" "this" {
  for_each = toset(var.expected_secret_names)

  name         = each.key
  value        = "placeholder"  # Ignored for imported secrets
  key_vault_id = azurerm_key_vault.this.id

  lifecycle {
    ignore_changes = [value]
  }
}
