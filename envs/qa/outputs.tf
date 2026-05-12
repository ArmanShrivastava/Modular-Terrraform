output "key_vault_uri" {
  value = module.key_vault.vault_uri
}

output "front_door_id" {
  value = module.front_door.id
}

output "application_gateway_id" {
  value = module.application_gateway.id
}
