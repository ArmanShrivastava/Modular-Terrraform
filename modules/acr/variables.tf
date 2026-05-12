variable "name" {
  type        = string
  description = "Azure Container Registry name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group containing the registry."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "sku" {
  type        = string
  description = "ACR SKU."
  default     = "Standard"
}

variable "admin_enabled" {
  type        = bool
  description = "Whether the ACR admin user is enabled."
  default     = false
}

variable "public_network_access_enabled" {
  type        = bool
  description = "Whether public network access is enabled."
  default     = true
}

variable "anonymous_pull_enabled" {
  type        = bool
  description = "Whether anonymous image pulls are enabled."
  default     = false
}

variable "data_endpoint_enabled" {
  type        = bool
  description = "Whether dedicated data endpoints are enabled."
  default     = false
}

variable "retention_policy_enabled" {
  type        = bool
  description = "Whether untagged manifest retention is enabled."
  default     = false
}

variable "retention_policy_days" {
  type        = number
  description = "Retention period for untagged manifests."
  default     = 7
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the registry."
  default     = {}
}
