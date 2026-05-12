variable "subscription_id" {
  type        = string
  description = "Azure subscription ID."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group containing the Front Door Standard/Premium profile."
}

variable "name" {
  type        = string
  description = "Front Door profile name."
}

variable "notes" {
  type        = string
  description = "Migration notes for this existing Front Door profile."
  default     = "Model Front Door incrementally: profile, endpoints, origin groups, origins, custom domains, routes, rule sets, and security policy."
}
