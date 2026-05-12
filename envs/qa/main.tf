module "key_vault" {
  source = "../../modules/key-vault"

  name                          = "metacode-kyvlt-qa"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  tenant_id                     = var.tenant_id
  sku_name                      = "standard"
  enable_rbac_authorization     = true
  public_network_access_enabled = true
  soft_delete_retention_days    = 90
  manage_secret_values          = var.manage_secret_values
  secrets                       = var.key_vault_secrets
  expected_secret_names         = local.sms_secret_names
  tags                          = local.tags
}

module "front_door" {
  source = "../../modules/front-door-placeholder"

  subscription_id     = var.subscription_id
  resource_group_name = var.resource_group_name
  name                = "sms-frontdoor-nonprod"
}

module "application_gateway" {
  source = "../../modules/application-gateway-placeholder"

  subscription_id     = var.subscription_id
  resource_group_name = var.resource_group_name
  name                = "sms-appgw-nonprod"
}
