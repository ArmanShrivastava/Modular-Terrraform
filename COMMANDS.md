# End-to-End Commands

Use these commands after installing Terraform and Azure CLI.

## Install tools

```bash
brew install terraform
brew install azure-cli
```

```bash
terraform version
az version
```

## Login to Azure

```bash
az login
```

```bash
az account set --subscription 11318a43-071d-4fda-b43a-bd719a191760
```

```bash
az account show --query "{name:name, subscription:id, tenant:tenantId}" -o table
```

## Format Terraform

```bash
cd /Users/armanshrivastava/Downloads/SMS
terraform fmt -recursive .
```

## Dev import

```bash
cd /Users/armanshrivastava/Downloads/SMS/envs/dev
terraform init
```

```bash
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
```

```bash
terraform plan
terraform plan > dev-plan.txt
less dev-plan.txt
```

## QA import

```bash
cd /Users/armanshrivastava/Downloads/SMS/envs/qa
terraform init
```

```bash
terraform import module.key_vault.azurerm_key_vault.this /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa
```

```bash
terraform plan
terraform plan > qa-plan.txt
less qa-plan.txt
```

## Apply only after review

```bash
cd /Users/armanshrivastava/Downloads/SMS/envs/dev
terraform apply
```

```bash
cd /Users/armanshrivastava/Downloads/SMS/envs/qa
terraform apply
```

Do not apply if the plan shows resource replacement for existing resources.
