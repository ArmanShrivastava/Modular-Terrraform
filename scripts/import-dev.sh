#!/usr/bin/env sh
set -eu

terraform import module.acr.azurerm_container_registry.this /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerRegistry/registries/SMSACRDEV
terraform import module.key_vault.azurerm_key_vault.this /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev
terraform import module.network.azurerm_virtual_network.this /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net
terraform import 'module.network.azurerm_subnet.this["appgw-subnet"]' /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/appgw-subnet
terraform import 'module.network.azurerm_subnet.this["jumpbox-subnet"]' /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/jumpbox-subnet
terraform import 'module.network.azurerm_subnet.this["aks-subnet"]' /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/aks-subnet
terraform import 'module.network.azurerm_subnet.this["private-endpoints-subnet"]' /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/private-endpoints-subnet
terraform import 'module.network.azurerm_subnet.this["ado-agents-subnet"]' /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/ado-agents-subnet
terraform import module.aks.azurerm_kubernetes_cluster.this /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerService/managedClusters/sms-aks-dev-cluster
terraform import 'module.aks.azurerm_kubernetes_cluster_node_pool.this["userpool"]' /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerService/managedClusters/sms-aks-dev-cluster/agentPools/userpool
terraform import 'module.aks.azurerm_kubernetes_cluster_node_pool.this["uipool"]' /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerService/managedClusters/sms-aks-dev-cluster/agentPools/uipool
