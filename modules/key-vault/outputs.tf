output "id" {
  description = "Key Vault resource ID."
  value       = azurerm_key_vault.this.id
}

output "vault_uri" {
  description = "Key Vault URI."
  value       = azurerm_key_vault.this.vault_uri
}

output "expected_secret_names" {
  description = "Secret names expected to exist."
  value       = var.expected_secret_names
}
