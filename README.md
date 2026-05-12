# SMS Terraform

Terraform structure for managing the existing SMS non-production Azure estate.

The code is split into reusable modules and environment roots:

```text
.
├── envs
│   ├── dev
│   └── qa
├── modules
│   ├── acr
│   ├── aks
│   ├── application-gateway-placeholder
│   ├── front-door-placeholder
│   ├── key-vault
│   ├── network
│   └── vm-placeholder
├── docs
└── scripts
```

## How to use

1. Login to Azure:

```bash
az login
az account set --subscription 11318a43-071d-4fda-b43a-bd719a191760
```

2. Start with one environment:

```bash
cd envs/dev
terraform init
terraform plan
```

3. Import already-created resources before applying:

```bash
terraform import module.acr.azurerm_container_registry.this /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerRegistry/registries/SMSACRDEV
terraform import module.key_vault.azurerm_key_vault.this /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev
terraform import module.network.azurerm_virtual_network.this /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net
terraform import module.aks.azurerm_kubernetes_cluster.this /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerService/managedClusters/sms-aks-dev-cluster
```

4. After import, run:

```bash
terraform plan
```

Review drift carefully. For existing production-like resources, apply only after the plan is clean and expected.

## Adding UAT later

Copy `envs/qa` to `envs/uat`, update `terraform.tfvars`, and add/import UAT resources. Keep shared module code unchanged unless the platform design changes.

## Notes

- Key Vault secret values are intentionally not committed. Set `manage_secret_values = true` and pass secret values securely only when Terraform should own them.
- Application Gateway, Front Door, and VMs are represented as placeholders with import guidance because portal-exported ARM for those resources is very large and often contains generated/read-only fields. Convert them module-by-module after import planning, so Terraform does not accidentally recreate live traffic resources.
