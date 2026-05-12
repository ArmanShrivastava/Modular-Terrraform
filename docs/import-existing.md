# Import Existing Azure Resources

These resources were already created in Azure. Import them before applying Terraform.

## Dev

```bash
cd envs/dev
terraform init

terraform import module.acr.azurerm_container_registry.this /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerRegistry/registries/SMSACRDEV
terraform import module.key_vault.azurerm_key_vault.this /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev
terraform import module.network.azurerm_virtual_network.this /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net
terraform import module.aks.azurerm_kubernetes_cluster.this /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerService/managedClusters/sms-aks-dev-cluster
```

Import subnets if you choose to let Terraform manage subnet resources separately:

```bash
terraform import 'module.network.azurerm_subnet.this["appgw-subnet"]' /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/appgw-subnet
terraform import 'module.network.azurerm_subnet.this["jumpbox-subnet"]' /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/jumpbox-subnet
terraform import 'module.network.azurerm_subnet.this["aks-subnet"]' /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/aks-subnet
terraform import 'module.network.azurerm_subnet.this["private-endpoints-subnet"]' /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/private-endpoints-subnet
terraform import 'module.network.azurerm_subnet.this["ado-agents-subnet"]' /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/ado-agents-subnet
```

## QA

```bash
cd envs/qa
terraform init

terraform import module.key_vault.azurerm_key_vault.this /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa
```

## Recommended workflow

1. Import one module at a time.
2. Run `terraform plan`.
3. Adjust module variables until the plan shows no accidental replacement.
4. Only then apply intentional changes.
