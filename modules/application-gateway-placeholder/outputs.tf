output "id" {
  description = "Existing Application Gateway resource ID."
  value       = local.import_id
}

output "migration_notes" {
  description = "Guidance for converting this placeholder."
  value       = var.notes
}
