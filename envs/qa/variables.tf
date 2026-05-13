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

variable "jumpbox_admin_password" {
  type        = string
  description = "Admin password for jumpbox VM"
  sensitive   = true
}

variable "vm_admin_password" {
  type        = string
  description = "Admin password for general purpose VMs"
  sensitive   = true
}

variable "ddos_protection_plan_id" {
  type        = string
  description = "DDoS protection plan resource ID"
  default     = null
}

variable "peering_remote_vnet_id" {
  type        = string
  description = "Remote virtual network ID for peering"
  default     = null
}

variable "deploy_app_gateway" {
  type        = bool
  description = "Deploy application gateway"
  default     = true
}

variable "appgw_public_ip_id" {
  type        = string
  description = "Public IP ID for Application Gateway"
  default     = ""
}
