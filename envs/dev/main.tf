module "acr" {
  source = "../../modules/acr"

  name                = "SMSACRDEV"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"
  admin_enabled       = true
  tags = {
    SMS = "AKS"
  }
}

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

module "network" {
  source = "../../modules/network"

  name                    = "sms-net"
  resource_group_name     = var.resource_group_name
  location                = var.location
  address_space           = ["10.0.0.0/16"]
  ddos_protection_plan_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/ddosProtectionPlans/DDosProtectionPlan"
  tags                    = local.tags

  subnets = {
    appgw-subnet = {
      address_prefixes          = ["10.0.1.0/24"]
      network_security_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/appgw-nsg"
    }
    jumpbox-subnet = {
      address_prefixes          = ["10.0.5.0/26"]
      network_security_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/jumpbox-nsg"
    }
    aks-subnet = {
      address_prefixes          = ["10.0.2.0/23"]
      network_security_group_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/aks-nsg"
      service_endpoints         = ["Microsoft.Sql"]
    }
    private-endpoints-subnet = {
      address_prefixes                  = ["10.0.4.0/24"]
      network_security_group_id         = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/private-endpoints-nsg"
      service_endpoints                 = ["Microsoft.Sql"]
      private_endpoint_network_policies = "Disabled"
    }
    ado-agents-subnet = {
      address_prefixes                  = ["10.0.20.0/24"]
      network_security_group_id         = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/networkSecurityGroups/ado-agent-nsg"
      private_endpoint_network_policies = "Disabled"
    }
  }

  peerings = {
    sms-nonprod-agent-dev-aks = {
      remote_virtual_network_id    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/vnet-uksouth"
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
    }
  }
}

module "aks" {
  source = "../../modules/aks"

  name                              = "sms-aks-dev-cluster"
  resource_group_name               = var.resource_group_name
  location                          = var.location
  tenant_id                         = var.tenant_id
  dns_prefix                        = "sms-aks-dev-cluster-dns"
  kubernetes_version                = "1.34.6"
  node_resource_group               = "MC_SMS-RG_sms-aks-dev-cluster_uksouth"
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
}

module "application_gateway" {
  source = "../../modules/application-gateway-placeholder"

  subscription_id     = var.subscription_id
  resource_group_name = var.resource_group_name
  name                = "sms-appgw-nonprod"
}

module "front_door" {
  source = "../../modules/front-door-placeholder"

  subscription_id     = var.subscription_id
  resource_group_name = var.resource_group_name
  name                = "sms-frontdoor-nonprod"
}

module "jumpbox" {
  source = "../../modules/vm-placeholder"

  subscription_id     = var.subscription_id
  resource_group_name = var.resource_group_name
  name                = "sms-jumpbox"
}

module "sms_non_prod_vm" {
  source = "../../modules/vm-placeholder"

  subscription_id     = var.subscription_id
  resource_group_name = var.resource_group_name
  name                = "SMS-Non-Prod-1"
}
