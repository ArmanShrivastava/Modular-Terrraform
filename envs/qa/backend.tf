terraform {
  backend "azurerm" {
    resource_group_name  = "SMS-RG"
    storage_account_name = "satfstatemetacode"
    container_name       = "tfstate"
    key                  = "qa.terraform.tfstate"
  }
}
