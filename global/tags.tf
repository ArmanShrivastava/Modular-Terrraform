locals {
  common_tags = {
    Environment  = var.environment
    Application  = var.application_name
    ManagedBy    = "Terraform"
    CreatedDate  = formatdate("YYYY-MM-DD", timestamp())
    CostCenter   = var.cost_center
    Owner        = var.owner
    Compliance   = var.compliance_tag
    BackupPolicy = var.backup_policy
    MonitoringLevel = var.monitoring_level
  }

  tags = merge(
    local.common_tags,
    var.additional_tags
  )
}
