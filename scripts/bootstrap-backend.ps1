#!/usr/bin/env pwsh
<#
.SYNOPSIS
Bootstrap Terraform backend infrastructure in Azure Storage Account

.DESCRIPTION
Creates the necessary Azure resources for Terraform remote state management:
- Resource Group
- Storage Account
- Container
- Enables state locking

.PARAMETER SubscriptionId
Azure subscription ID

.PARAMETER ResourceGroupName
Resource group name for backend (default: terraform-backend)

.PARAMETER StorageAccountName
Storage account name for state (default: smstertfstate)

.PARAMETER Location
Azure region (default: uksouth)

.EXAMPLE
.\bootstrap-backend.ps1 -SubscriptionId "11318a43-071d-4fda-b43a-bd719a191760"
#>

param(
    [string]$SubscriptionId = "11318a43-071d-4fda-b43a-bd719a191760",
    [string]$ResourceGroupName = "SMS-RG",
    [string]$StorageAccountName = "satfstatemetacode",
    [string]$Location = "uksouth",
    [string]$ContainerName = "tfstate"
)

# Color functions
function Write-Success { Write-Host "✓ $args" -ForegroundColor Green }
function Write-Error { Write-Host "✗ $args" -ForegroundColor Red }
function Write-Info { Write-Host "ℹ $args" -ForegroundColor Cyan }
function Write-Section { Write-Host "`n>>> $args <<<`n" -ForegroundColor Yellow }

$ErrorActionPreference = "Stop"

# Set subscription
Write-Section "Setting Azure Subscription"
az account set --subscription $SubscriptionId
if ($LASTEXITCODE -eq 0) {
    Write-Success "Switched to subscription: $SubscriptionId"
}

# Create Resource Group
Write-Section "Creating Resource Group"
$rgCheck = az group exists --name $ResourceGroupName | ConvertFrom-Json
if ($rgCheck) {
    Write-Info "Resource group already exists: $ResourceGroupName"
} else {
    Write-Info "Creating resource group: $ResourceGroupName"
    az group create `
        --name $ResourceGroupName `
        --location $Location `
        | Out-Null
    Write-Success "Created resource group: $ResourceGroupName"
}

# Create Storage Account
Write-Section "Creating Storage Account"
$saCheck = az storage account show `
    --name $StorageAccountName `
    --resource-group $ResourceGroupName `
    -ErrorAction SilentlyContinue

if ($saCheck) {
    Write-Info "Storage account already exists: $StorageAccountName"
} else {
    Write-Info "Creating storage account: $StorageAccountName"
    az storage account create `
        --name $StorageAccountName `
        --resource-group $ResourceGroupName `
        --location $Location `
        --sku Standard_LRS `
        --kind StorageV2 `
        --https-only true `
        --min-tls-version TLS1_2 `
        | Out-Null
    Write-Success "Created storage account: $StorageAccountName"
}

# Get Storage Account Key
Write-Section "Getting Storage Account Key"
$storageKey = az storage account keys list `
    --account-name $StorageAccountName `
    --resource-group $ResourceGroupName `
    --query "[0].value" -o tsv

Write-Success "Retrieved storage account key"

# Create Container
Write-Section "Creating Storage Container"
$containerCheck = az storage container exists `
    --account-name $StorageAccountName `
    --account-key $storageKey `
    --name $ContainerName `
    --query exists | ConvertFrom-Json

if ($containerCheck) {
    Write-Info "Container already exists: $ContainerName"
} else {
    Write-Info "Creating container: $ContainerName"
    az storage container create `
        --account-name $StorageAccountName `
        --account-key $storageKey `
        --name $ContainerName `
        | Out-Null
    Write-Success "Created container: $ContainerName"
}

# Enable blob versioning and soft delete
Write-Section "Enabling Storage Security Features"
Write-Info "Enabling blob versioning..."
az storage blob service-properties update `
    --account-name $StorageAccountName `
    --account-key $storageKey `
    --enable-versioning true `
    | Out-Null
Write-Success "Blob versioning enabled"

Write-Info "Enabling soft delete..."
az storage blob service-properties delete-policy update `
    --account-name $StorageAccountName `
    --account-key $storageKey `
    --days-retained 30 `
    --enable true `
    | Out-Null
Write-Success "Soft delete enabled for 30 days"

# Create DEV state file
Write-Section "Creating State Files"
Write-Info "Creating dev.terraform.tfstate placeholder..."
$devStateBlob = az storage blob exists `
    --account-name $StorageAccountName `
    --account-key $storageKey `
    --container-name $ContainerName `
    --name "dev.terraform.tfstate" `
    --query exists | ConvertFrom-Json

if (-not $devStateBlob) {
    echo '{}' | az storage blob upload `
        --account-name $StorageAccountName `
        --account-key $storageKey `
        --container-name $ContainerName `
        --name "dev.terraform.tfstate" `
        --file /dev/stdin `
        --overwrite `
        | Out-Null
    Write-Success "Created dev.terraform.tfstate"
}

# Create QA state file
Write-Info "Creating qa.terraform.tfstate placeholder..."
$qaStateBlob = az storage blob exists `
    --account-name $StorageAccountName `
    --account-key $storageKey `
    --container-name $ContainerName `
    --name "qa.terraform.tfstate" `
    --query exists | ConvertFrom-Json

if (-not $qaStateBlob) {
    echo '{}' | az storage blob upload `
        --account-name $StorageAccountName `
        --account-key $storageKey `
        --container-name $ContainerName `
        --name "qa.terraform.tfstate" `
        --file /dev/stdin `
        --overwrite `
        | Out-Null
    Write-Success "Created qa.terraform.tfstate"
}

# Display summary
Write-Section "Backend Bootstrap Complete"

