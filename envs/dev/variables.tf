variable "subscription_id" {
  type        = string
  description = "Azure subscription ID."
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "resource_group_name" {
  type        = string
  description = "Primary SMS resource group."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "Existing Log Analytics workspace resource ID used by AKS."
}

variable "manage_secret_values" {
  type        = bool
  description = "Set true only when Terraform should create/update Key Vault secret values."
  default     = false
}

variable "key_vault_secrets" {
  type        = map(string)
  description = "Key Vault secrets. Keep real values out of git."
  default     = {}
  sensitive   = true
}
