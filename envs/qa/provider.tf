provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  features {
    key_vault {
      purge_soft_delete_on_destroy      = false
      recover_soft_deleted_key_vaults   = true
    }
    virtual_machine {
      delete_os_disk_on_deletion = true
    }
  }
}

provider "azuread" {
  tenant_id = var.tenant_id
}
