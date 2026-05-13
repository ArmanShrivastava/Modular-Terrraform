output "storage_account_ids" {
  value = {
    metastorageaccnonprod    = azurerm_storage_account.metastorageaccnonprod.id
    satfstatemetacode        = azurerm_storage_account.satfstatemetacode.id
    smsblobstorageaccountdev = azurerm_storage_account.smsblobstorageaccountdev.id
  }
  description = "Map of Storage Account IDs"
}

output "storage_account_names" {
  value = {
    metastorageaccnonprod    = azurerm_storage_account.metastorageaccnonprod.name
    satfstatemetacode        = azurerm_storage_account.satfstatemetacode.name
    smsblobstorageaccountdev = azurerm_storage_account.smsblobstorageaccountdev.name
  }
  description = "Map of Storage Account names"
}

output "storage_account_primary_blob_endpoints" {
  value = {
    metastorageaccnonprod    = azurerm_storage_account.metastorageaccnonprod.primary_blob_endpoint
    satfstatemetacode        = azurerm_storage_account.satfstatemetacode.primary_blob_endpoint
    smsblobstorageaccountdev = azurerm_storage_account.smsblobstorageaccountdev.primary_blob_endpoint
  }
  description = "Map of primary blob endpoints"
}

output "storage_account_primary_file_endpoints" {
  value = {
    metastorageaccnonprod    = azurerm_storage_account.metastorageaccnonprod.primary_file_endpoint
    satfstatemetacode        = azurerm_storage_account.satfstatemetacode.primary_file_endpoint
    smsblobstorageaccountdev = azurerm_storage_account.smsblobstorageaccountdev.primary_file_endpoint
  }
  description = "Map of primary file endpoints"
}

output "container_ids" {
  value = {}
  description = "Map of storage container IDs"
}

output "file_share_ids" {
  value = {}
  description = "Map of storage file share IDs"
}

output "queue_ids" {
  value = {}
  description = "Map of storage queue IDs"
}

output "table_ids" {
  value = {}
  description = "Map of storage table IDs"
}
