#!/usr/bin/env sh
set -eu

# Import existing Azure resources into Terraform state for DEV environment

# Azure Container Registry
terraform import 'module.acr.azurerm_container_registry.this' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerRegistry/registries/SMSACRDEV'

# Key Vault
terraform import 'module.key_vault.azurerm_key_vault.this' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev'

# Network - Virtual Network and Subnets
terraform import 'module.network.azurerm_virtual_network.this' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net'
terraform import 'module.network.azurerm_subnet.this["appgw-subnet"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/appgw-subnet'
terraform import 'module.network.azurerm_subnet.this["jumpbox-subnet"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/jumpbox-subnet'
terraform import 'module.network.azurerm_subnet.this["aks-subnet"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/aks-subnet'
terraform import 'module.network.azurerm_subnet.this["private-endpoints-subnet"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/private-endpoints-subnet'
terraform import 'module.network.azurerm_subnet.this["ado-agents-subnet"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/ado-agents-subnet'

# Network Security Groups
terraform import 'module.network_security_groups.azurerm_network_security_group.this["appgw-nsg"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/networkSecurityGroups/appgw-nsg'
terraform import 'module.network_security_groups.azurerm_network_security_group.this["jumpbox-nsg"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/networkSecurityGroups/jumpbox-nsg'

# Storage Account
terraform import 'module.storage.azurerm_storage_account.metastorageaccnonprod' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Storage/storageAccounts/metastorageaccnonprod'

# AKS Cluster and Node Pools
terraform import 'module.aks.azurerm_kubernetes_cluster.this' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerService/managedClusters/sms-aks-dev-cluster'
terraform import 'module.aks.azurerm_kubernetes_cluster_node_pool.this["userpool"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerService/managedClusters/sms-aks-dev-cluster/agentPools/userpool'
terraform import 'module.aks.azurerm_kubernetes_cluster_node_pool.this["uipool"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerService/managedClusters/sms-aks-dev-cluster/agentPools/uipool'

# Virtual Machines
terraform import 'module.vm.azurerm_windows_virtual_machine.this["sms-jumpbox"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Compute/virtualMachines/sms-jumpbox'
terraform import 'module.vm.azurerm_windows_virtual_machine.this["SMS-Non-Prod-1"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Compute/virtualMachines/SMS-Non-Prod-1'

# Application Gateway
terraform import 'module.application_gateway.azurerm_application_gateway.this' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/applicationGateways/sms-appgw-nonprod'

# Front Door (placeholder - skip if not implemented)
# terraform import 'module.front_door.azurerm_frontdoor.this' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/frontDoors/sms-frontdoor-nonprod'

# Key Vault Secrets
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AppConString"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AppConString'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-ApplicationInsights-InstrumentationKey"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-ApplicationInsights-InstrumentationKey'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AppManagerDbConStr"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AppManagerDbConStr'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureBlobStorage-ConnectionString"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureBlobStorage-ConnectionString'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureDirectory-ClientId"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureDirectory-ClientId'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureDirectory-ClientSecret"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureDirectory-ClientSecret'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureDirectory-TenantId"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureDirectory-TenantId'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureRedisCache-ConnectionString"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureRedisCache-ConnectionString'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-ConnectionString"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureServiceBus-ConnectionString'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-QueueMenuBuildName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureServiceBus-QueueMenuBuildName'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-QueueName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureServiceBus-QueueName'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-QueueNotificationName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureServiceBus-QueueNotificationName'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-QueueUserBuildName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureServiceBus-QueueUserBuildName'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-QueueWorkFlowBuildName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureServiceBus-QueueWorkFlowBuildName'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-TopicName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureServiceBus-TopicName'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-JwtSettings-Key"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-JwtSettings-Key'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-Settings-EncryptDecryptKey"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-Settings-EncryptDecryptKey'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-SmsDatabasePasswd"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-SmsDatabasePasswd'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-SmsDatabaseUser"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-SmsDatabaseUser'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-SmsSmtpPasswd"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-SmsSmtpPasswd'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-SmsSubscriptionId"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-SmsSubscriptionId'

# Network - Virtual Network and Subnets
terraform import 'module.network.azurerm_virtual_network.this' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net'
terraform import 'module.network.azurerm_subnet.this["appgw-subnet"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/appgw-subnet'
terraform import 'module.network.azurerm_subnet.this["jumpbox-subnet"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/jumpbox-subnet'
terraform import 'module.network.azurerm_subnet.this["aks-subnet"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/aks-subnet'
terraform import 'module.network.azurerm_subnet.this["private-endpoints-subnet"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/private-endpoints-subnet'
terraform import 'module.network.azurerm_subnet.this["ado-agents-subnet"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/ado-agents-subnet'

# Network Security Groups
terraform import 'module.network_security_groups.azurerm_network_security_group.this["appgw-nsg"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/networkSecurityGroups/appgw-nsg'
terraform import 'module.network_security_groups.azurerm_network_security_group.this["jumpbox-nsg"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/networkSecurityGroups/jumpbox-nsg'

# Storage Account
terraform import 'module.storage.azurerm_storage_account.metastorageaccnonprod' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Storage/storageAccounts/metastorageaccnonprod'

# AKS Cluster and Node Pools
terraform import 'module.aks.azurerm_kubernetes_cluster.this' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerService/managedClusters/sms-aks-dev-cluster'
terraform import 'module.aks.azurerm_kubernetes_cluster_node_pool.this["userpool"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerService/managedClusters/sms-aks-dev-cluster/agentPools/userpool'
terraform import 'module.aks.azurerm_kubernetes_cluster_node_pool.this["uipool"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerService/managedClusters/sms-aks-dev-cluster/agentPools/uipool'

# Virtual Machines
terraform import 'module.vm.azurerm_windows_virtual_machine.this["sms-jumpbox"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Compute/virtualMachines/sms-jumpbox'
terraform import 'module.vm.azurerm_windows_virtual_machine.this["SMS-Non-Prod-1"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Compute/virtualMachines/SMS-Non-Prod-1'

# Application Gateway
terraform import 'module.application_gateway.azurerm_application_gateway.this' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/applicationGateways/sms-appgw-nonprod'

# Front Door (placeholder - skip if not implemented)
# terraform import 'module.front_door.azurerm_frontdoor.this' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/frontDoors/sms-frontdoor-nonprod'

# Key Vault Secrets
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AppConString"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AppConString'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-ApplicationInsights-InstrumentationKey"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-ApplicationInsights-InstrumentationKey'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AppManagerDbConStr"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AppManagerDbConStr'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureBlobStorage-ConnectionString"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureBlobStorage-ConnectionString'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureDirectory-ClientId"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureDirectory-ClientId'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureDirectory-ClientSecret"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureDirectory-ClientSecret'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureDirectory-TenantId"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureDirectory-TenantId'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureRedisCache-ConnectionString"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureRedisCache-ConnectionString'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-ConnectionString"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureServiceBus-ConnectionString'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-QueueMenuBuildName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureServiceBus-QueueMenuBuildName'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-QueueName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureServiceBus-QueueName'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-QueueNotificationName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureServiceBus-QueueNotificationName'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-QueueUserBuildName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureServiceBus-QueueUserBuildName'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-QueueWorkFlowBuildName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureServiceBus-QueueWorkFlowBuildName'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-TopicName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-AzureServiceBus-TopicName'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-JwtSettings-Key"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-JwtSettings-Key'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-Settings-EncryptDecryptKey"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-Settings-EncryptDecryptKey'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-SmsDatabasePasswd"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-SmsDatabasePasswd'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-SmsDatabaseUser"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-SmsDatabaseUser'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-SmsSmtpPasswd"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-SmsSmtpPasswd'
terraform import 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-SmsSubscriptionId"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev/secrets/AppSettings-SmsSubscriptionId'
