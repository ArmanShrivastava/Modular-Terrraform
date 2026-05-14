#!/usr/bin/env sh
set -eu

# Import existing Azure resources into Terraform state for QA environment

# Azure Container Registry (already imported)
# terraform import -lock=false 'module.acr.azurerm_container_registry.this' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerRegistry/registries/SMSACRDEV'

# Network Security Groups
terraform import -lock=false 'module.network_security_groups.azurerm_network_security_group.this["appgw-nsg"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/networkSecurityGroups/appgw-nsg'
terraform import -lock=false 'module.network_security_groups.azurerm_network_security_group.this["jumpbox-nsg"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/networkSecurityGroups/jumpbox-nsg'
terraform import -lock=false 'module.network_security_groups.azurerm_network_security_group.this["aks-nsg"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/networkSecurityGroups/aks-nsg'
terraform import -lock=false 'module.network_security_groups.azurerm_network_security_group.this["private-endpoints-nsg"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/networkSecurityGroups/private-endpoints-nsg'
terraform import -lock=false 'module.network_security_groups.azurerm_network_security_group.this["ado-agent-nsg"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/networkSecurityGroups/ado-agent-nsg'

# Key Vault
terraform import -lock=false 'module.key_vault.azurerm_key_vault.this' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa'

# Storage Account
terraform import -lock=false 'module.storage.azurerm_storage_account.metastorageaccnonprod' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Storage/storageAccounts/metastorageaccnonprod'

# AKS Cluster and Node Pools (commented out - no QA cluster exists)
# terraform import -lock=false 'module.aks.azurerm_kubernetes_cluster.this' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerService/managedClusters/sms-aks-qa-cluster'
# terraform import -lock=false 'module.aks.azurerm_kubernetes_cluster_node_pool.this["userpool"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerService/managedClusters/sms-aks-qa-cluster/agentPools/userpool'
# terraform import -lock=false 'module.aks.azurerm_kubernetes_cluster_node_pool.this["uipool"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerService/managedClusters/sms-aks-qa-cluster/agentPools/uipool'

# Virtual Machines
terraform import -lock=false 'module.vm.azurerm_windows_virtual_machine.this["sms-jumpbox"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Compute/virtualMachines/sms-jumpbox'
terraform import -lock=false 'module.vm.azurerm_windows_virtual_machine.this["SMS-Non-Prod-1"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Compute/virtualMachines/SMS-Non-Prod-1'

# Application Gateway
terraform import -lock=false 'module.application_gateway.azurerm_application_gateway.this' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/applicationGateways/sms-appgw-nonprod'

# Front Door (placeholder - skip if not implemented)
# terraform import -lock=false 'module.front_door.azurerm_frontdoor.this' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/frontDoors/sms-frontdoor-nonprod'

# Key Vault Secrets
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AppConString"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-AppConString'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-ApplicationInsights-InstrumentationKey"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-ApplicationInsights-InstrumentationKey'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AppManagerDbConStr"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-AppManagerDbConStr'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureBlobStorage-ConnectionString"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-AzureBlobStorage-ConnectionString'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureDirectory-ClientId"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-AzureDirectory-ClientId'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureDirectory-ClientSecret"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-AzureDirectory-ClientSecret'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureDirectory-TenantId"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-AzureDirectory-TenantId'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureRedisCache-ConnectionString"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-AzureRedisCache-ConnectionString'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-ConnectionString"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-AzureServiceBus-ConnectionString'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-QueueMenuBuildName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-AzureServiceBus-QueueMenuBuildName'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-QueueName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-AzureServiceBus-QueueName'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-QueueNotificationName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-AzureServiceBus-QueueNotificationName'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-QueueUserBuildName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-AzureServiceBus-QueueUserBuildName'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-QueueWorkFlowBuildName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-AzureServiceBus-QueueWorkFlowBuildName'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-AzureServiceBus-TopicName"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-AzureServiceBus-TopicName'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-JwtSettings-Key"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-JwtSettings-Key'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-Settings-EncryptDecryptKey"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-Settings-EncryptDecryptKey'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-SmsDatabasePasswd"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-SmsDatabasePasswd'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-SmsDatabaseUser"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-SmsDatabaseUser'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-SmsSmtpPasswd"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-SmsSmtpPasswd'
terraform import -lock=false 'module.key_vault.azurerm_key_vault_secret.this["AppSettings-SmsSubscriptionId"]' '/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa/secrets/AppSettings-SmsSubscriptionId'