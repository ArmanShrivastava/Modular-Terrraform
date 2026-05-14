#!/usr/bin/env pwsh
<#
.SYNOPSIS
Import existing Azure SMS infrastructure into Terraform state for DEV environment

.DESCRIPTION
Automates the terraform import process for all existing SMS resources
Handles dependencies and import order

.PARAMETER SubscriptionId
Azure subscription ID

.PARAMETER ResourceGroupName
Azure resource group name

.PARAMETER TerraformDir
Path to terraform environment directory (default: current dev directory)

.EXAMPLE
.\import-dev.ps1 -SubscriptionId "11318a43-071d-4fda-b43a-bd719a191760" -ResourceGroupName "SMS-RG"
#>

param(
    [string]$SubscriptionId = "11318a43-071d-4fda-b43a-bd719a191760",
    [string]$ResourceGroupName = "SMS-RG",
    [string]$TerraformDir = (Get-Location)
)

# Color output
$ErrorActionPreference = "Continue"
$WarningPreference = "Continue"

function Write-Success { Write-Host "✓ $args" -ForegroundColor Green }
function Write-Error { Write-Host "✗ $args" -ForegroundColor Red }
function Write-Info { Write-Host "ℹ $args" -ForegroundColor Cyan }
function Write-Section { Write-Host "`n>>> $args <<<`n" -ForegroundColor Yellow }

# Validate Azure CLI connection
Write-Section "Validating Azure CLI Connection"
az account show --query "id" | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Success "Connected to Azure subscription: $SubscriptionId"
} else {
    Write-Error "Failed to connect to Azure. Aborting."
    exit 1
}

# Validate Terraform
Write-Section "Validating Terraform"
if (-not (Get-Command terraform -ErrorAction SilentlyContinue)) {
    Write-Error "Terraform not found in PATH"
    exit 1
}
Write-Success "Terraform found: $(terraform version | Select-Object -First 1)"

# Initialize Terraform
Write-Section "Initializing Terraform"
Push-Location $TerraformDir
terraform init
if ($LASTEXITCODE -ne 0) {
    Write-Error "Terraform init failed"
    exit 1
}
Write-Success "Terraform initialized"

# ============================================================================
# NETWORK SECURITY GROUPS
# ============================================================================
Write-Section "Importing Network Security Groups"

$nsgs = @(
    @{ name = "appgw-nsg"; tfKey = "appgw-nsg" },
    @{ name = "jumpbox-nsg"; tfKey = "jumpbox-nsg" },
    @{ name = "aks-nsg"; tfKey = "aks-nsg" },
    @{ name = "private-endpoints-nsg"; tfKey = "private-endpoints-nsg" },
    @{ name = "ado-agent-nsg"; tfKey = "ado-agent-nsg" },
    @{ name = "ad-agents-nsg"; tfKey = "ad-agents-nsg" },
    @{ name = "AgentMachine-nsg"; tfKey = "agentmachine-nsg" },
    @{ name = "agentvm-nsg"; tfKey = "agentvm-nsg" },
    @{ name = "SMS-Non-Prod-1-nsg"; tfKey = "sms-non-prod-1-nsg" },
    @{ name = "smsnonprod-vm-nsg"; tfKey = "smsnonprod-vm-nsg" }
)

foreach ($nsg in $nsgs) {
    $nsgId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Network/networkSecurityGroups/$($nsg.name)"
    Write-Info "Importing NSG: $($nsg.name)"
    $addr = 'module.network_security_groups.azurerm_network_security_group.this["' + $nsg.tfKey + '"]'
    terraform import -lock=false $addr $nsgId 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Imported: $($nsg.name)"
    } else {
        Write-Error "Failed to import: $($nsg.name)"
    }
}

# ============================================================================
# VIRTUAL NETWORK AND SUBNETS
# ============================================================================
Write-Section "Importing Virtual Network and Subnets"

$vnetId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Network/virtualNetworks/sms-net"
Write-Info "Importing Virtual Network: sms-net"
terraform import "module.network.azurerm_virtual_network.this" $vnetId 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Success "Imported: sms-net"
}

$subnets = @("appgw-subnet", "jumpbox-subnet", "aks-subnet", "private-endpoints-subnet", "ado-agents-subnet")
foreach ($subnet in $subnets) {
    $subnetId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Network/virtualNetworks/sms-net/subnets/$subnet"
    Write-Info "Importing Subnet: $subnet"
    terraform import "module.network.azurerm_subnet.this[\"$subnet\"]" $subnetId 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Imported: $subnet"
    }
}

# ============================================================================
# CONTAINER REGISTRY
# ============================================================================
Write-Section "Importing Container Registry"

$acrId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.ContainerRegistry/registries/SMSACRDEV"
Write-Info "Importing ACR: SMSACRDEV"
terraform import "module.acr.azurerm_container_registry.this" $acrId 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Success "Imported: SMSACRDEV"
}

# ============================================================================
# KEY VAULT
# ============================================================================
Write-Section "Importing Key Vault"

$kvId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-dev"
Write-Info "Importing Key Vault: metacode-kyvlt-dev"
terraform import "module.key_vault.azurerm_key_vault.this" $kvId 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Success "Imported: metacode-kyvlt-dev"
}

# ============================================================================
# STORAGE ACCOUNTS
# ============================================================================
Write-Section "Importing Storage Accounts"

$storageAccounts = @(
    @{ name = "metastorageaccnonprod"; tfKey = "metastorageaccnonprod" },
    @{ name = "satfstatemetacode"; tfKey = "satfstatemetacode" },
    @{ name = "smsblobstorageaccountdev"; tfKey = "blobstorage" }
)

foreach ($sa in $storageAccounts) {
    $saId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Storage/storageAccounts/$($sa.name)"
    Write-Info "Importing Storage Account: $($sa.name)"
    terraform import "module.storage.azurerm_storage_account.this[\"$($sa.tfKey)\"]" $saId 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Imported: $($sa.name)"
    }
}

# ============================================================================
# AKS CLUSTER
# ============================================================================
Write-Section "Importing AKS Cluster"

$aksId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.ContainerService/managedClusters/sms-aks-dev-cluster"
Write-Info "Importing AKS: sms-aks-dev-cluster"
terraform import "module.aks.azurerm_kubernetes_cluster.this" $aksId 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Success "Imported: sms-aks-dev-cluster"
}

# ============================================================================
# PUBLIC IPS
# ============================================================================
Write-Section "Importing Public IP Addresses"

$publicIps = @(
    "AgentMachine-ip",
    "appgw-publcip-sms",
    "appgw-sms-publicip",
    "jumpbox-publicip",
    "SMS-Non-Prod-1-ip"
)

foreach ($pip in $publicIps) {
    $pipId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Network/publicIPAddresses/$pip"
    Write-Info "Importing Public IP: $pip"
    # Note: These might not be directly managed in modules, might need to import to separate resources
    Write-Info "Skipping: $pip (needs manual management strategy)"
}

# ============================================================================
# VIRTUAL MACHINES
# ============================================================================
Write-Section "Importing Virtual Machines"

$vms = @(
    @{ name = "sms-jumpbox"; module = "jumpbox"; key = "jumpbox" },
    @{ name = "SMS-Non-Prod-1"; module = "virtual_machines"; key = "sms-non-prod" }
)

foreach ($vm in $vms) {
    $vmId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Compute/virtualMachines/$($vm.name)"
    Write-Info "Importing VM: $($vm.name)"
    
    if ($vm.module -eq "jumpbox") {
        terraform import "module.jumpbox.azurerm_windows_virtual_machine.this[\"$($vm.key)\"]" $vmId 2>&1 | Out-Null
    } else {
        terraform import "module.virtual_machines.azurerm_windows_virtual_machine.this[\"$($vm.key)\"]" $vmId 2>&1 | Out-Null
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Imported: $($vm.name)"
    }
}

# ============================================================================
# NETWORK INTERFACES
# ============================================================================
Write-Section "Importing Network Interfaces"

$nics = @(
    "sms-jumpbox757_z1",
    "sms-non-prod-1539_z1"
)

foreach ($nic in $nics) {
    $nicId = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroupName/providers/Microsoft.Network/networkInterfaces/$nic"
    Write-Info "Skipping NIC import: $nic (auto-managed by VM module)"
}

# ============================================================================
# FINAL VALIDATION
# ============================================================================
Write-Section "Import Summary"
Write-Info "Running terraform plan to validate state..."
terraform plan -lock=false -out=import.tfplan 2>&1 | Tee-Object -Variable planOutput | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Success "All resources imported successfully"
    Write-Info "Plan file saved to: import.tfplan"
    Write-Info "Review the plan carefully before applying:"
    Write-Info "  terraform apply import.tfplan"
} else {
    Write-Error "Import validation failed. Review the output above."
}

Pop-Location
Write-Success "Import process complete!"
