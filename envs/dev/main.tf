# SMS Development Environment - Main Configuration
# Manages all SMS infrastructure components for DEV environment

# Network Security Groups
module "network_security_groups" {
  source = "../../modules/nsg"

  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags

  network_security_groups = {
    "appgw-nsg" = {
      name = "appgw-nsg"
      inbound_rules = [
        {
          name                      = "allow-http"
          priority                  = 100
          access                    = "Allow"
          protocol                  = "Tcp"
          source_address_prefix     = "*"
          destination_port_range    = "80"
        },
        {
          name                      = "allow-https"
          priority                  = 101
          access                    = "Allow"
          protocol                  = "Tcp"
          source_address_prefix     = "*"
          destination_port_range    = "443"
        }
      ]
    }
    "jumpbox-nsg" = {
      name = "jumpbox-nsg"
      inbound_rules = [
        {
          name                      = "allow-rdp"
          priority                  = 100
          access                    = "Allow"
          protocol                  = "Tcp"
          destination_port_range    = "3389"
        },
        {
          name                      = "allow-ssh"
          priority                  = 101
          access                    = "Allow"
          protocol                  = "Tcp"
          destination_port_range    = "22"
        }
      ]
    }
    "aks-nsg" = {
      name = "aks-nsg"
      inbound_rules = [
        {
          name                      = "allow-internal"
          priority                  = 100
          access                    = "Allow"
          protocol                  = "*"
          source_address_prefix     = "10.0.0.0/16"
          destination_address_prefix = "*"
        }
      ]
    }
    "private-endpoints-nsg" = {
      name = "private-endpoints-nsg"
      inbound_rules = [
        {
          name                      = "allow-https-from-vnet"
          priority                  = 100
          access                    = "Allow"
          protocol                  = "Tcp"
          source_address_prefix     = "10.0.0.0/16"
          destination_port_range    = "443"
        }
      ]
    }
    "ado-agent-nsg" = {
      name = "ado-agent-nsg"
      inbound_rules = [
        {
          name                      = "allow-internal"
          priority                  = 100
          access                    = "Allow"
          protocol                  = "*"
          source_address_prefix     = "10.0.0.0/16"
        }
      ]
    }
  }
}

# Virtual Network and Subnets
module "network" {
  source = "../../modules/network"

  name                = "sms-net"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
  tags                = local.tags

  subnets = {
    "appgw-subnet" = {
      address_prefixes = ["10.0.1.0/24"]
    }
    "jumpbox-subnet" = {
      address_prefixes = ["10.0.5.0/26"]
    }
    "aks-subnet" = {
      address_prefixes = ["10.0.2.0/23"]
      service_endpoints = ["Microsoft.Sql"]
    }
    "private-endpoints-subnet" = {
      address_prefixes = ["10.0.4.0/24"]
      service_endpoints = ["Microsoft.Sql"]
      private_endpoint_network_policies = "Disabled"
    }
    "ado-agents-subnet" = {
      address_prefixes = ["10.0.20.0/24"]
      private_endpoint_network_policies = "Disabled"
    }
  }

  peerings = var.peering_remote_vnet_id == null ? {} : {
    sms-dev-peering = {
      remote_virtual_network_id    = var.peering_remote_vnet_id
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      allow_gateway_transit        = false
      use_remote_gateways          = false
    }
  }

  depends_on = [module.network_security_groups]
}

# Container Registry
module "acr" {
  source = "../../modules/acr"

  name                = "SMSACRDEV"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
  tags                = local.tags
}

# Key Vault
module "key_vault" {
  source = "../../modules/key-vault"

  name                          = "metacode-kyvlt-dev"
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

# Storage Accounts
module "storage" {
  source = "../../modules/storage"

  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags

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

# AKS Cluster
module "aks" {
  source = "../../modules/aks"

  name                              = "sms-aks-dev-cluster"
  resource_group_name               = var.resource_group_name
  location                          = var.location
  tenant_id                         = var.tenant_id
  dns_prefix                        = "sms-aks-dev-cluster-dns"
  kubernetes_version                = "1.34.6"
  node_resource_group               = "MC_${var.resource_group_name}_sms-aks-dev-cluster_${var.location}"
  sku_tier                          = "Standard"
  private_cluster_enabled           = true
  private_dns_zone_id               = "System"
  azure_policy_enabled              = true
  oidc_issuer_enabled               = true
  workload_identity_enabled         = true
  local_account_disabled            = false
  service_cidr                      = "10.1.0.0/16"
  dns_service_ip                    = "10.1.0.10"
  log_analytics_workspace_id        = var.log_analytics_workspace_id
  tags                              = local.tags

  default_node_pool = {
    name            = "agentpool"
    vm_size         = "Standard_D2as_v5"
    vnet_subnet_id  = module.network.subnet_ids["aks-subnet"]
    zones           = ["1", "2", "3"]
    min_count       = 2
    max_count       = 5
    max_pods        = 30
    os_disk_size_gb = 128
  }

  user_node_pools = {
    userpool = {
      vm_size         = "Standard_D2s_v5"
      vnet_subnet_id  = module.network.subnet_ids["aks-subnet"]
      zones           = ["1", "2", "3"]
      min_count       = 2
      max_count       = 5
      max_pods        = 19
      os_disk_size_gb = 128
    }
    uipool = {
      vm_size         = "Standard_D2s_v5"
      vnet_subnet_id  = module.network.subnet_ids["aks-subnet"]
      min_count       = 3
      max_count       = 5
      max_pods        = 30
      os_disk_size_gb = 128
      node_labels = {
        tier     = "frontend"
        workload = "ui"
      }
      node_taints = ["workload=ui:NoSchedule"]
    }
  }

  depends_on = [module.network]
}

# Virtual Machines - Jumpbox
module "jumpbox" {
  source = "../../modules/vm"

  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
  create_windows_vms  = true
  create_linux_vms    = false

  virtual_machines = {
    jumpbox = {
      name                   = "sms-jumpbox"
      vm_size                = "Standard_B2s"
      subnet_id              = module.network.subnet_ids["jumpbox-subnet"]
      admin_username         = "azureuser"
      admin_password         = var.jumpbox_admin_password
      create_public_ip       = true
      source_image_reference = {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2022-Datacenter"
        version   = "latest"
      }
    }
  }

  depends_on = [module.network]
}

# Virtual Machines - General Purpose
module "virtual_machines" {
  source = "../../modules/vm"

  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = local.tags
  create_windows_vms  = true
  create_linux_vms    = false

  virtual_machines = {
    sms_non_prod = {
      name                   = "SMS-Non-Prod-1"
      vm_size                = "Standard_B4ms"
      subnet_id              = module.network.subnet_ids["aks-subnet"]
      admin_username         = "azureuser"
      admin_password         = var.vm_admin_password
      create_public_ip       = false
      source_image_reference = {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2022-Datacenter"
        version   = "latest"
      }
      data_disks = [
        {
          size_gb              = 256
          storage_account_type = "Premium_LRS"
        }
      ]
    }
  }

  depends_on = [module.network]
}

# Application Gateway
module "application_gateway" {
  count   = var.deploy_app_gateway ? 1 : 0
  source  = "../../modules/application-gateway"

  name                = "sms-appgw-dev"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard_v2"
  sku_tier            = "Standard_v2"
  capacity            = 2

  gateway_ip_config_name = "gateway-ip-config"
  subnet_id              = module.network.subnet_ids["appgw-subnet"]
  public_ip_address_id   = try(var.appgw_public_ip_id, "")

  frontend_ports = [
    { name = "http"; port = 80 },
    { name = "https"; port = 443 }
  ]

  backend_pools = [
    {
      name         = "backend-pool"
      ip_addresses = []
    }
  ]

  backend_http_settings = [
    {
      name     = "http-settings"
      port     = 80
      protocol = "Http"
    }
  ]

  http_listeners = [
    {
      name               = "http-listener"
      frontend_port_name = "http"
      protocol           = "Http"
    }
  ]

  request_routing_rules = [
    {
      name                       = "http-rule"
      http_listener_name         = "http-listener"
      backend_address_pool_name  = "backend-pool"
      backend_http_settings_name = "http-settings"
    }
  ]

  tags = local.tags

  depends_on = [module.network]
}
