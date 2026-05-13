# SMS Terraform Deployment Guide

Complete step-by-step guide to set up, configure, and deploy SMS infrastructure using Terraform.

## Quick Start (5 minutes)

```bash
# 1. Clone repository
git clone https://github.com/ArmanShrivastava/Modular-Terrraform.git
cd Modular-Terrraform

# 2. Authenticate
az login
az account set --subscription 11318a43-071d-4fda-b43a-bd719a191760

# 3. Bootstrap backend
pwsh scripts/bootstrap-backend.ps1

# 4. Initialize DEV
cd envs/dev
terraform init

# 5. Plan
terraform plan -out=tfplan

# 6. Import existing resources
cd ../..
pwsh scripts/import-dev.ps1

# 7. Apply
cd envs/dev
terraform apply tfplan
```

---

## Step-by-Step Setup

### Prerequisites Checklist

- [ ] Terraform 1.5.0+ installed
- [ ] Azure CLI 2.50.0+ installed  
- [ ] Git installed
- [ ] PowerShell 7.0+ installed
- [ ] Azure subscription access (11318a43-071d-4fda-b43a-bd719a191760)
- [ ] Contributor or Owner RBAC role
- [ ] Key Vault Administrator role (for Key Vault)

### Installation Verification

```bash
# Check versions
terraform version        # Should be >= 1.5.0
az --version            # Should be >= 2.50.0
pwsh --version          # Should be >= 7.0

# Verify Git
git --version
```

---

## Phase 1: Environment Setup (15 minutes)

### Step 1.1: Clone Repository

```bash
# Clone the repository
git clone https://github.com/ArmanShrivastava/Modular-Terrraform.git

# Navigate to repository
cd Modular-Terrraform

# Verify structure
ls -la
# Expected output:
# envs/
# modules/
# scripts/
# pipelines/
# global/
# README.md
```

### Step 1.2: Azure Authentication

```bash
# Login to Azure
az login

# Select subscription
az account set --subscription 11318a43-071d-4fda-b43a-bd719a191760

# Verify
az account show

# Expected output should show:
# "id": "11318a43-071d-4fda-b43a-bd719a191760"
# "name": "GG-SMS"
```

### Step 1.3: Verify Permissions

```bash
# Check role assignments
az role assignment list --scope /subscriptions/11318a43-071d-4fda-b43a-bd719a191760

# Should see:
# - Owner or Contributor role
# - Scoped to subscription
```

---

## Phase 2: Backend Setup (10 minutes)

The remote backend stores Terraform state in Azure Storage Account.

### Step 2.1: Run Bootstrap Script

```bash
# Navigate to scripts directory
cd scripts

# Run bootstrap (creates all backend infrastructure)
pwsh bootstrap-backend.ps1 `
  -SubscriptionId "11318a43-071d-4fda-b43a-bd719a191760" `
  -ResourceGroupName "terraform-backend" `
  -StorageAccountName "smstertfstate" `
  -Location "uksouth"

# Expected output:
# ✓ Switched to subscription: ...
# ✓ Created resource group: terraform-backend
# ✓ Created storage account: smstertfstate
# ✓ Created container: tfstate
# ✓ Backend Bootstrap Complete
```

### Step 2.2: Verify Backend Resources

```bash
# Check resource group
az group show --name terraform-backend

# Check storage account
az storage account show --name smstertfstate --resource-group terraform-backend

# Check container
az storage container list \
  --account-name smstertfstate \
  --query "[].name"
```

### Step 2.3: Backend Configuration Verification

The backend.tf files should already be configured:

```bash
# Check DEV backend
cat ../envs/dev/backend.tf

# Check QA backend  
cat ../envs/qa/backend.tf

# Both should reference:
# - resource_group_name: terraform-backend
# - storage_account_name: smstertfstate
# - container_name: tfstate
# - key: dev.terraform.tfstate or qa.terraform.tfstate
```

---

## Phase 3: Environment Configuration (20 minutes)

### Step 3.1: Prepare DEV Configuration

```bash
# Navigate to DEV environment
cd ../envs/dev

# Copy example variables
cp terraform.tfvars.example terraform.tfvars

# Edit with real values
vim terraform.tfvars
```

### Step 3.2: Configure terraform.tfvars (DEV)

Edit `envs/dev/terraform.tfvars`:

```hcl
# Basic Configuration
subscription_id = "11318a43-071d-4fda-b43a-bd719a191760"
tenant_id       = "7b137d3d-85e1-4661-adcb-1508632797fb"
location        = "uksouth"
resource_group_name = "SMS-RG"

# Log Analytics (existing workspace)
log_analytics_workspace_id = "/subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/DefaultResourceGroup-SUK/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-11318a43-071d-4fda-b43a-bd719a191760-SUK"

# VM Credentials (KEEP SECURE!)
jumpbox_admin_password = "ComplexPassword123!@#"  # Change this!
vm_admin_password      = "ComplexPassword123!@#"  # Change this!

# Optional Features
deploy_app_gateway = true
manage_secret_values = false

# Tags
additional_tags = {
  Environment = "DEV"
  CostCenter  = "ENG001"
  Owner       = "sms-team@company.com"
}
```

### Step 3.3: Prepare QA Configuration

```bash
# Navigate to QA environment
cd ../qa

# Copy example variables
cp terraform.tfvars.example terraform.tfvars

# Edit for QA
vim terraform.tfvars
```

### Step 3.4: Configure terraform.tfvars (QA)

Edit `envs/qa/terraform.tfvars` with QA-specific values (same structure as DEV).

---

## Phase 4: Initialize Terraform (10 minutes)

### Step 4.1: Initialize DEV Environment

```bash
# Navigate to DEV environment
cd envs/dev

# Initialize Terraform with backend
terraform init \
  -backend-config="resource_group_name=terraform-backend" \
  -backend-config="storage_account_name=smstertfstate" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=dev.terraform.tfstate"

# Expected output:
# Initializing the backend...
# Initializing modules...
# Initializing provider plugins...
# Terraform has been successfully initialized!
```

### Step 4.2: Verify DEV State

```bash
# List resources in state (should be empty initially)
terraform state list

# Check backend configuration
terraform backend show
```

### Step 4.3: Initialize QA Environment

```bash
# Navigate to QA
cd ../qa

# Initialize with QA state file
terraform init \
  -backend-config="resource_group_name=terraform-backend" \
  -backend-config="storage_account_name=smstertfstate" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=qa.terraform.tfstate"
```

---

## Phase 5: Import Existing Resources (30 minutes)

The SMS infrastructure already exists in Azure. We need to import it into Terraform state.

### Step 5.1: Automated Import (Recommended)

```bash
# Navigate to scripts
cd ../../scripts

# Run import script for DEV
pwsh import-dev.ps1 `
  -SubscriptionId "11318a43-071d-4fda-b43a-bd719a191760" `
  -ResourceGroupName "SMS-RG" `
  -TerraformDir "../envs/dev"

# Expected output:
# >>> Importing Network Security Groups <<<
# ✓ Imported: aks-nsg
# ✓ Imported: appgw-nsg
# ✓ Imported: jumpbox-nsg
# ... more imports ...
# >>> Import Summary <<<
# ✓ All resources imported successfully
```

### Step 5.2: Verify Imports

```bash
# Navigate to DEV
cd ../envs/dev

# List imported resources
terraform state list

# Should show something like:
# module.acr.azurerm_container_registry.this
# module.aks.azurerm_kubernetes_cluster.this
# module.key_vault.azurerm_key_vault.this
# module.network.azurerm_subnet.this["aks-subnet"]
# module.network.azurerm_virtual_network.this
# ... and more
```

### Step 5.3: Plan Import

```bash
# Review what Terraform sees
terraform plan

# Expected output:
# No changes. Infrastructure is up-to-date.
# 
# This means Terraform state matches actual Azure resources
```

---

## Phase 6: Validate Configuration (15 minutes)

### Step 6.1: Format Check

```bash
# Check code formatting
terraform fmt -check -recursive

# If issues found, auto-format:
terraform fmt -recursive
```

### Step 6.2: Validation

```bash
# Validate Terraform code
terraform validate

# Expected output:
# Success! The configuration is valid.
```

### Step 6.3: Security Check

```bash
# Install Checkov
pip install checkov

# Run security scan
cd ../..
checkov -d . --framework terraform --quiet

# Review any findings
```

---

## Phase 7: First Plan & Apply (20 minutes)

### Step 7.1: Create Plan

```bash
# Navigate to DEV
cd envs/dev

# Create plan file
terraform plan -out=tfplan

# Typical output shows:
# Plan: 0 to add, 0 to change, 0 to destroy.
# (No changes since we imported existing resources)
```

### Step 7.2: Review Plan

```bash
# Show plan details
terraform show tfplan

# Review all changes carefully
```

### Step 7.3: Apply Plan

```bash
# Apply the plan
terraform apply tfplan

# Expected output:
# Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

### Step 7.4: Verify State

```bash
# Verify state was saved
terraform state list | wc -l
# Should show the number of imported resources

# Check storage account for state file
az storage blob show \
  --account-name smstertfstate \
  --container-name tfstate \
  --name dev.terraform.tfstate
```

---

## Phase 8: Set Up CI/CD Pipeline (25 minutes)

### Step 8.1: Create Azure DevOps Project

1. Go to [Azure DevOps](https://dev.azure.com)
2. Create new project: `SMS-Terraform`
3. Repository: Import `https://github.com/ArmanShrivastava/Modular-Terrraform.git`

### Step 8.2: Create Service Connection

```bash
# Service connection to Azure for Terraform
# In Azure DevOps UI:
# Project Settings → Service connections → New service connection
# Type: Azure Resource Manager
# Authentication method: Service principal (automatic)
# Scope: Subscription
# Resource group: leave blank
# Service connection name: SMS-Azure
```

### Step 8.3: Create Variable Groups

In Azure DevOps:

```
Library → Variable groups → Create

Variable Group: terraform-dev
- subscription_id: 11318a43-071d-4fda-b43a-bd719a191760
- tenant_id: 7b137d3d-85e1-4661-adcb-1508632797fb
- resource_group_name: SMS-RG
- location: uksouth

Variable Group: terraform-qa
- (Same as above, QA-specific values)
```

### Step 8.4: Create Pipeline

```bash
# In Azure DevOps:
# Pipelines → Create Pipeline
# Repository: Modular-Terrraform
# Configure: Existing Azure Pipelines YAML file
# Path: pipelines/azure-pipelines.yml
# Save and run
```

---

## Maintenance & Operations

### Regular Tasks

#### Weekly
```bash
# Check for Terraform updates
terraform init -upgrade

# Review security alerts
```

#### Monthly
```bash
# Backup state
cd envs/dev
terraform state pull > state.backup-$(date +%Y%m%d).json

# Verify plan shows no drift
terraform plan
```

#### Quarterly
```bash
# Update provider versions
# Edit global/versions.tf
# Run terraform init -upgrade
```

---

## Troubleshooting

### Issue: Authentication Failed

```bash
# Solution: Re-authenticate
az login
az account set --subscription 11318a43-071d-4fda-b43a-bd719a191760

# Verify
az account show
```

### Issue: Backend Not Initialized

```bash
# Solution: Run backend bootstrap
cd scripts
pwsh bootstrap-backend.ps1
```

### Issue: Import Failed

```bash
# Solution: Check resource exists
az resource show --ids /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.Network/networkSecurityGroups/aks-nsg

# Verify Terraform initialized
cd envs/dev
terraform init
```

### Issue: State Locked

```bash
# Solution: Unlock
terraform force-unlock <LOCK_ID>

# Or wait for lock to expire (10 minutes)
```

---

## Next Steps

### After Successful Deployment

1. **Set up Monitoring**
   - Enable Azure Monitor diagnostics
   - Create alerts for resource health

2. **Configure RBAC**
   - Assign roles to team members
   - Enable audit logging

3. **Plan Updates**
   - Test changes in DEV first
   - Use PR process for code review
   - Deploy to QA before PROD

4. **Documentation**
   - Document custom configurations
   - Keep runbooks updated
   - Record any manual changes

---

## Support & Resources

- **Terraform Docs**: https://www.terraform.io/docs
- **Azure Provider**: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
- **Azure CLI**: https://learn.microsoft.com/en-us/cli/azure/
- **Repository Issues**: GitHub Issues

---

## Common Commands Reference

```bash
# Terraform Workflow
terraform init                    # Initialize
terraform fmt                     # Format code
terraform validate               # Validate syntax
terraform plan                   # Preview changes
terraform apply                  # Apply changes
terraform destroy                # Remove resources

# State Management
terraform state list             # List all resources
terraform state show <resource>  # Show resource details
terraform state rm <resource>    # Remove from state
terraform state pull             # Download state

# Debugging
terraform console               # Interactive console
TF_LOG=DEBUG terraform plan     # Debug logging
terraform version               # Show version

# Azure CLI Reference
az resource list                                    # List resources
az resource show --ids <RESOURCE_ID>              # Show resource
az account show                                    # Show subscription
az group list                                     # List resource groups
```

---

**Last Updated**: May 2026  
**Version**: 1.0.0  
**Maintained By**: SMS DevOps Team
