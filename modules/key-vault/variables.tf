variable "name" {
  type        = string
  description = "Key Vault name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group containing the Key Vault."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID."
}

variable "sku_name" {
  type        = string
  description = "Key Vault SKU."
  default     = "standard"
}

variable "enabled_for_deployment" {
  type        = bool
  description = "Allow Azure VMs to retrieve certificates."
  default     = false
}

variable "enabled_for_disk_encryption" {
  type        = bool
  description = "Allow Azure Disk Encryption access."
  default     = false
}

variable "enabled_for_template_deployment" {
  type        = bool
  description = "Allow ARM template deployments to retrieve secrets."
  default     = false
}

variable "enable_rbac_authorization" {
  type        = bool
  description = "Use Azure RBAC instead of access policies."
  default     = true
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is enabled."
  default     = true
}

variable "soft_delete_retention_days" {
  type        = number
  description = "Soft delete retention in days."
  default     = 90
}

variable "purge_protection_enabled" {
  type        = bool
  description = "Whether purge protection is enabled."
  default     = false
}

variable "manage_secret_values" {
  type        = bool
  description = "Set true only when Terraform should create/update Key Vault secret values."
  default     = false
}

variable "secrets" {
  type        = map(string)
  description = "Secret values keyed by Key Vault secret name. Keep these outside git."
  default     = {}
  sensitive   = true
}

variable "expected_secret_names" {
  type        = set(string)
  description = "Secret names expected to exist in this vault. Documentation only unless manage_secret_values is true."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the Key Vault."
  default     = {}
}
