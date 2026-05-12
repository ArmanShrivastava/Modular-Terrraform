output "id" {
  description = "Existing VM resource ID."
  value       = local.import_id
}

output "migration_notes" {
  description = "Guidance for converting this placeholder."
  value       = var.notes
}
