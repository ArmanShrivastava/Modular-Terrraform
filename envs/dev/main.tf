# SMS Development Environment - Main Configuration
# Manages all SMS infrastructure components for DEV environment

# Network Security Groups
module "network_security_groups" {
  source = "../../modules/nsg"

  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
}

# Virtual Network and Subnets
module "network" {
  source = "../../modules/network"

  name                    = "sms-net"
  resource_group_name     = var.resource_group_name
  location                = var.location
  address_space           = ["10.0.0.0/16"]
  tags                    = local.tags

  subnets = {
    appgw-subnet = {
      address_prefixes          = ["10.0.1.0/24"]
    }
    jumpbox-subnet = {
      address_prefixes          = ["10.0.5.0/26"]
    }
    aks-subnet = {
      address_prefixes          = ["10.0.2.0/23"]
      service_endpoints         = ["Microsoft.Sql"]
    }
    private-endpoints-subnet = {
      address_prefixes                  = ["10.0.4.0/24"]
      service_endpoints                 = ["Microsoft.Sql"]
      private_endpoint_network_policies = "Disabled"
    }
    ado-agents-subnet = {
      address_prefixes                  = ["10.0.20.0/24"]
      private_endpoint_network_policies = "Disabled"
    }
  }
}

# Storage Accounts
module "storage" {
  source = "../../modules/storage"

  resource_group_name = var.resource_group_name
  location            = var.location

  storage_accounts = {
    metastorageaccnonprod = {
      name                     = "metastorageaccnonprod"
      account_tier             = "Standard"
      account_replication_type = "GRS"
    }
    satfstatemetacode = {
      name                     = "satfstatemetacode"
      account_tier             = "Standard"
      account_replication_type = "GRS"
    }
    smsblobstorageaccountdev = {
      name                     = "smsblobstorageaccountdev"
      account_tier             = "Standard"
      account_replication_type = "GRS"
    }
  }
}