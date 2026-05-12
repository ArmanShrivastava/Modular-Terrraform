variable "subscription_id" {
  type        = string
  description = "Azure subscription ID."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group containing the Application Gateway."
}

variable "name" {
  type        = string
  description = "Application Gateway name."
}

variable "notes" {
  type        = string
  description = "Migration notes for this existing Application Gateway."
  default     = "Convert this placeholder to a native azurerm_application_gateway module after comparing plan drift from the portal export."
}
