#!/usr/bin/env sh
set -eu

terraform import module.key_vault.azurerm_key_vault.this /subscriptions/11318a43-071d-4fda-b43a-bd719a191760/resourceGroups/SMS-RG/providers/Microsoft.KeyVault/vaults/metacode-kyvlt-qa
