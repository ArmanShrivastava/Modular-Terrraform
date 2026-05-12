output "acr_login_server" {
  value = module.acr.login_server
}

output "key_vault_uri" {
  value = module.key_vault.vault_uri
}

output "aks_id" {
  value = module.aks.id
}

output "application_gateway_id" {
  value = module.application_gateway.id
}

output "front_door_id" {
  value = module.front_door.id
}
