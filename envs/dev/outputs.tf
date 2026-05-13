output "acr_login_server" {
  value       = module.acr.login_server
  description = "ACR login server URL."
}

output "key_vault_uri" {
  value       = module.key_vault.vault_uri
  description = "Key Vault URI."
}

output "aks_id" {
  value       = module.aks.id
  description = "AKS cluster resource ID."
}

output "application_gateway_id" {
  value       = try(module.application_gateway[0].id, "")
  description = "Application Gateway resource ID when enabled."
}
