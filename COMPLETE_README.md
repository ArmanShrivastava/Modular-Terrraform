# SMS Terraform Infrastructure

Complete enterprise-grade Terraform codebase for managing SMS infrastructure across DEV, QA, UAT, and PROD environments.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Prerequisites](#prerequisites)
3. [Repository Structure](#repository-structure)
4. [Quick Start](#quick-start)
5. [Environment Setup](#environment-setup)
6. [Import Existing Resources](#import-existing-resources)
7. [Terraform Workflow](#terraform-workflow)
8. [Module Documentation](#module-documentation)
9. [State Management](#state-management)
10. [CI/CD Integration](#cicd-integration)
11. [Troubleshooting](#troubleshooting)

---

## Architecture Overview

This Terraform codebase implements a modular, reusable architecture for SMS infrastructure:

### Key Principles
- **Modular Design**: Each Azure service has its own reusable module
- **Environment Separation**: Isolated configurations for DEV, QA, UAT, and PROD
- **State Management**: Remote backend in Azure Storage Account with locking
- **Infrastructure as Code**: All resources defined and versionable
- **Security**: Sensitive values handled securely with Key Vault integration
- **Compliance**: Comprehensive tagging, monitoring, and audit trails

### Supported Azure Services
- Virtual Networks & Subnets
- Network Security Groups
- VMs (Windows & Linux)
- AKS (Azure Kubernetes Service)
- Container Registry (ACR)
- Application Gateway
- Key Vault
- Storage Accounts
- And more...

---

## Prerequisites

### Required Tools
1. **Terraform** >= 1.5.0
   ```bash
   terraform version
   ```

2. **Azure CLI** >= 2.50.0
   ```bash
   az --version
   ```

3. **Git** (for version control)

4. **PowerShell** 7.0+ (for import scripts)

### Azure Requirements
- Access to Azure subscription: `11318a43-071d-4fda-b43a-bd719a191760`
- Resource group: `SMS-RG`
- Appropriate RBAC permissions:
  - Owner or Contributor role
  - Key Vault Administrator (for Key Vault management)

### Environment Variables
```bash
# Export subscription details
export ARM_SUBSCRIPTION_ID="11318a43-071d-4fda-b43a-bd719a191760"
export ARM_TENANT_ID="7b137d3d-85e1-4661-adcb-1508632797fb"

# Optional: For automation
export ARM_CLIENT_ID="<service-principal-app-id>"
export ARM_CLIENT_SECRET="<service-principal-password>"
export ARM_SKIP_PROVIDER_REGISTRATION=true
```

---

## Repository Structure

```
terraform-sms/
│
├── global/                      # Global configurations
│   ├── naming.tf               # Naming conventions
│   ├── tags.tf                 # Common tagging strategy
│   ├── variables.tf            # Global variables
│   └── versions.tf             # Provider versions
│
├── modules/                     # Reusable modules
│   ├── network/                # VNet, Subnets, Peering
│   ├── nsg/                    # Network Security Groups
│   ├── vm/                     # Virtual Machines
│   ├── aks/                    # AKS Cluster
│   ├── acr/                    # Container Registry
│   ├── application-gateway/    # Application Gateway
│   ├── key-vault/              # Key Vault
│   ├── storage/                # Storage Accounts
│   └── [other modules]/
│
├── environments/               # Environment configurations
│   ├── dev/                    # Development
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   ├── backend.tf
│   │   ├── terraform.tfvars
│   │   └── locals.tf
│   │
│   ├── qa/                     # Quality Assurance
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   │   ├── backend.tf
│   │   ├── terraform.tfvars
│   │   └── locals.tf
│   │
│   └── [uat/, prod]/           # Add as needed
│
├── pipelines/                  # Azure DevOps Pipelines
│   ├── azure-pipelines.yml     # Main CI/CD pipeline
│   ├── templates/
│   │   ├── terraform-plan.yml
│   │   ├── terraform-apply.yml
│   │   └── terraform-destroy.yml
│
├── scripts/                    # Automation scripts
│   ├── import-dev.ps1         # Import DEV resources
│   ├── import-qa.ps1          # Import QA resources
│   ├── bootstrap-backend.ps1  # Setup remote backend
│   ├── validate.sh            # Validation script
│   └── format.sh              # Format checker
│
├── docs/                       # Documentation
│   ├── architecture.md
│   ├── import-existing.md
│   ├── state-migration.md
│   └── troubleshooting.md
│
├── .gitignore
├── .terraform/
├── .terraform.lock.hcl
├── README.md (this file)
└── versions.tf
```

---

## Quick Start

### 1. Clone Repository
```bash
git clone https://github.com/ArmanShrivastava/Modular-Terrraform.git
cd Modular-Terrraform
```

### 2. Authenticate with Azure
```bash
az login
az account set --subscription 11318a43-071d-4fda-b43a-bd719a191760
```

### 3. Initialize Development Environment
```bash
cd envs/dev
terraform init
```

### 4. Review Configuration
```bash
# Copy and edit terraform.tfvars
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with actual values
```

### 5. Plan Deployment
```bash
terraform plan -out=tfplan
```

### 6. Import Existing Resources
```bash
# See "Import Existing Resources" section below
```

---

## Environment Setup

### DEV Environment

#### Initialize
```bash
cd environments/dev
terraform init \
  -backend-config="resource_group_name=terraform-backend" \
  -backend-config="storage_account_name=tfstatestorage" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=dev.terraform.tfstate"
```

#### Configure Variables
Create `environments/dev/terraform.tfvars`:
```hcl
subscription_id = "11318a43-071d-4fda-b43a-bd719a191760"
tenant_id       = "7b137d3d-85e1-4661-adcb-1508632797fb"
location        = "uksouth"
resource_group_name = "SMS-RG"

log_analytics_workspace_id = "/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/DefaultResourceGroup-SUK/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-11318a43-071d-4fda-b43a-bd719a191760-SUK"

# VM Passwords (keep sensitive!)
jumpbox_admin_password = "P@ssw0rd123!" # Change this
vm_admin_password      = "P@ssw0rd123!" # Change this

# Optional configuration
deploy_app_gateway = true
```

### QA Environment

#### Initialize
```bash
cd environments/qa
terraform init \
  -backend-config="resource_group_name=terraform-backend" \
  -backend-config="storage_account_name=tfstatestorage" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=qa.terraform.tfstate"
```

#### Create from DEV
Copy the DEV environment and adapt:
```bash
cp -r environments/dev environments/qa
# Edit terraform.tfvars for QA-specific values
```

---

## Import Existing Resources

### Overview
The repository includes automated scripts to import existing Azure resources into Terraform state. This allows Terraform to manage already-deployed resources.

### Prerequisites for Import
- All resources must already exist in Azure
- Terraform state files must be initialized
- Proper RBAC permissions required

### Automated Import (Recommended)

#### For DEV Environment
```bash
pwsh scripts/import-dev.ps1 `
  -SubscriptionId "11318a43-071d-4fda-b43a-bd719a191760" `
  -ResourceGroupName "SMS-RG" `
  -TerraformDir "envs/dev"
```

#### For QA Environment
```bash
pwsh scripts/import-qa.ps1 `
  -SubscriptionId "11318a43-071d-4fda-b43a-bd719a191760" `
  -ResourceGroupName "SMS-RG" `
  -TerraformDir "envs/qa"
```

### Manual Import

If you need to import specific resources:

#### Network Security Groups
```bash
terraform import module.network_security_groups.azurerm_network_security_group.this[\"aks-nsg\"] \
  "/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/networkSecurityGroups/aks-nsg"
```

#### Virtual Network
```bash
terraform import module.network.azurerm_virtual_network.this \
  "/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net"
```

#### Subnets
```bash
terraform import module.network.azurerm_subnet.this[\"aks-subnet\"] \
  "/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/aks-subnet"
```

#### AKS Cluster
```bash
terraform import module.aks.azurerm_kubernetes_cluster.this \
  "/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerService/managedClusters/sms-aks-dev-cluster"
```

#### Container Registry
```bash
terraform import module.acr.azurerm_container_registry.this \
  "/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.ContainerRegistry/registries/SMSACRDEV"
```

#### Key Vault
```bash
terraform import module.key_vault.azurerm_key_vault.this \
  "/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev"
```

### Verify Import
After import, validate that resources are correctly imported:
```bash
terraform plan
# Should show: No changes. Infrastructure is up-to-date.
```

---

## Terraform Workflow

### Standard Workflow

#### 1. Make Changes
Edit module variables or add new resources:
```bash
# Edit environment configuration
vim environments/dev/main.tf
```

#### 2. Format Code
```bash
terraform fmt -recursive
```

#### 3. Validate
```bash
terraform validate
```

#### 4. Plan
```bash
cd environments/dev
terraform plan -out=tfplan
```

#### 5. Review Plan
Carefully review the planned changes:
```bash
terraform show tfplan
```

#### 6. Apply
```bash
terraform apply tfplan
```

### Destroy Resources (Use with caution!)
```bash
terraform destroy
```

### State Management Commands
```bash
# List all resources in state
terraform state list

# Show specific resource details
terraform state show module.network.azurerm_virtual_network.this

# Manual state edits (dangerous)
terraform state mv module.old.resource module.new.resource

# Remove from state (but not from Azure)
terraform state rm module.acr.azurerm_container_registry.this
```

---

## Module Documentation

### Network Module
Manages virtual networks, subnets, and peering.

**Usage:**
```hcl
module "network" {
  source = "../../modules/network"
  
  name                = "sms-vnet"
  location            = "uksouth"
  resource_group_name = "SMS-RG"
  address_space       = ["10.0.0.0/16"]
  
  subnets = {
    app-subnet = {
      address_prefixes = ["10.0.1.0/24"]
    }
  }
}
```

### NSG Module
Manages network security groups and rules.

**Usage:**
```hcl
module "nsgs" {
  source = "../../modules/nsg"
  
  location            = "uksouth"
  resource_group_name = "SMS-RG"
  
  network_security_groups = {
    app-nsg = {
      name = "app-nsg"
      inbound_rules = [
        {
          name                   = "allow-http"
          priority               = 100
          access                 = "Allow"
          protocol               = "Tcp"
          destination_port_range = "80"
        }
      ]
    }
  }
}
```

### VM Module
Manages virtual machines with disks, NICs, and extensions.

**Usage:**
```hcl
module "vms" {
  source = "../../modules/vm"
  
  location            = "uksouth"
  resource_group_name = "SMS-RG"
  create_windows_vms  = true
  
  virtual_machines = {
    jumpbox = {
      name            = "sms-jumpbox"
      vm_size         = "Standard_B2s"
      subnet_id       = module.network.subnet_ids["app-subnet"]
      admin_username  = "azureuser"
      admin_password  = var.admin_password
      create_public_ip = true
    }
  }
}
```

---

## State Management

### Remote Backend Configuration

The infrastructure uses a remote backend in Azure Storage Account for:
- Centralized state storage
- State locking (prevents concurrent modifications)
- Team collaboration
- Backup and recovery

#### Backend Setup
```bash
# Run bootstrap script to create backend infrastructure
pwsh scripts/bootstrap-backend.ps1 \
  -SubscriptionId "11318a43-071d-4fda-b43a-bd719a191760" \
  -ResourceGroupName "terraform-backend"
```

#### Backend Configuration File
`environments/dev/backend.tf`:
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-backend"
    storage_account_name = "tfstatestorage"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
```

### State Migration
To migrate state between backends:
```bash
# Backup current state
terraform state pull > state.backup.json

# Reconfigure backend
terraform init -migrate-state

# Verify
terraform state list
```

---

## CI/CD Integration

### Azure DevOps Pipeline

The repository includes an Azure DevOps YAML pipeline that:
- Validates Terraform code
- Runs security checks
- Plans changes
- Requires approval before apply
- Applies changes
- Maintains audit trails

#### Pipeline File
`pipelines/azure-pipelines.yml`

#### Setup
1. Import repository to Azure DevOps
2. Create pipeline from YAML file
3. Create variable groups:
   - `terraform-dev`: DEV environment variables
   - `terraform-qa`: QA environment variables
4. Create service connection to Azure
5. Run pipeline

#### Pipeline Stages
1. **Validation**
   - Terraform format check
   - Terraform validation
   - TFLint checks
   - Checkov security scan

2. **Plan**
   - Terraform plan
   - Publish plan artifact

3. **Approval**
   - Manual approval gate
   - Requires review of changes

4. **Apply**
   - Terraform apply
   - Publish state artifact

---

## Troubleshooting

### Common Issues

#### 1. Authentication Errors
```bash
# Re-authenticate with Azure
az login
az account set --subscription 11318a43-071d-4fda-b43a-bd719a191760

# Check credentials
az account show
```

#### 2. State Lock
```bash
# View locks
terraform force-unlock <LOCK_ID>
```

#### 3. Import Conflicts
If a resource cannot be imported because it already exists in state:
```bash
# Remove from state
terraform state rm module.resource.azurerm_resource.this

# Re-import
terraform import module.resource.azurerm_resource.this <RESOURCE_ID>
```

#### 4. Provider Issues
```bash
# Upgrade providers
terraform init -upgrade

# Clear provider cache
rm -rf .terraform/providers
terraform init
```

### Debug Mode
```bash
# Enable debug logging
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform.log

terraform plan
```

### Check Resource IDs
```bash
# Find resource IDs in Azure
az resource list --resource-group SMS-RG --query "[].id"
```

---

## Best Practices

### Before Deploying
1. ✅ Run `terraform plan`
2. ✅ Review changes carefully
3. ✅ Test in DEV first
4. ✅ Verify state backups
5. ✅ Ensure team communication

### Code Quality
1. ✅ Use consistent formatting: `terraform fmt`
2. ✅ Validate code: `terraform validate`
3. ✅ Use modules for reusability
4. ✅ Document complex logic
5. ✅ Follow naming conventions

### Security
1. ✅ Never commit sensitive values
2. ✅ Use Key Vault for secrets
3. ✅ Implement least privilege RBAC
4. ✅ Enable audit logging
5. ✅ Review security scans

### State Management
1. ✅ Always use remote backend
2. ✅ Enable state locking
3. ✅ Regular backups
4. ✅ Restrict state file access
5. ✅ Review access logs

---

## Getting Help

### Documentation
- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure CLI Reference](https://learn.microsoft.com/en-us/cli/azure/)

### Troubleshooting Resources
- [Terraform Troubleshooting Guide](docs/troubleshooting.md)
- [Common Errors](docs/common-errors.md)
- [Import Strategy](docs/import-existing.md)

---

## Support & Contribution

For issues, questions, or contributions:
1. Create an issue in the repository
2. Follow the issue template
3. Include relevant logs and configurations
4. Reference related documentation

---

**Last Updated**: May 2026
**Maintained By**: SMS DevOps Team
**Version**: 1.0.0
