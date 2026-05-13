# Azure Storage Account Module
# Manages storage accounts with containers, file shares, queues, tables, and diagnostics

resource "azurerm_storage_account" "metastorageaccnonprod" {
  name                     = "metastorageaccnonprod"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  access_tier                    = "Hot"
  https_traffic_only_enabled     = true
  min_tls_version                = "TLS1_2"
  public_network_access_enabled  = true
  shared_access_key_enabled      = true
  default_to_oauth_authentication = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_account" "satfstatemetacode" {
  name                     = "satfstatemetacode"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  access_tier                    = "Hot"
  https_traffic_only_enabled     = true
  min_tls_version                = "TLS1_2"
  public_network_access_enabled  = true
  shared_access_key_enabled      = true
  default_to_oauth_authentication = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_account" "smsblobstorageaccountdev" {
  name                     = "smsblobstorageaccountdev"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  public_network_access_enabled  = true
  shared_access_key_enabled      = true
  default_to_oauth_authentication = false

  lifecycle {
    prevent_destroy = true
  }
}
