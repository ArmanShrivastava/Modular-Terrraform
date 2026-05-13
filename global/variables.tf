variable "application_name" {
  type        = string
  description = "Application name for resource naming (e.g., 'sms', 'myapp')"
  validation {
    condition     = can(regex("^[a-z0-9]{2,8}$", var.application_name))
    error_message = "Application name must be 2-8 lowercase alphanumeric characters."
  }
}

variable "environment" {
  type        = string
  description = "Environment name (dev, qa, uat, prod)"
  validation {
    condition     = contains(["dev", "qa", "uat", "prod"], var.environment)
    error_message = "Environment must be dev, qa, uat, or prod."
  }
}

variable "location_short" {
  type        = string
  description = "Short location code (e.g., 'uksouth' -> 'uks', 'eastus' -> 'eus')"
  validation {
    condition     = length(var.location_short) <= 4
    error_message = "Location short code should be 3-4 characters."
  }
}

variable "cost_center" {
  type        = string
  description = "Cost center code for billing and cost tracking"
}

variable "owner" {
  type        = string
  description = "Owner/Team email or name"
}

variable "compliance_tag" {
  type        = string
  description = "Compliance requirement tag (e.g., 'PCI-DSS', 'HIPAA', 'SOC2')"
  default     = "Standard"
}

variable "backup_policy" {
  type        = string
  description = "Backup retention policy (e.g., 'Daily', 'Weekly', 'Monthly')"
  default     = "Daily"
}

variable "monitoring_level" {
  type        = string
  description = "Monitoring level (Basic, Standard, Enhanced, Critical)"
  default     = "Standard"
}

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags to apply to all resources"
  default     = {}
}
