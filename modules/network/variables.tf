variable "name" {
  type        = string
  description = "Virtual network name."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group containing the virtual network."
}

variable "location" {
  type        = string
  description = "Azure region."
}

variable "address_space" {
  type        = list(string)
  description = "Virtual network address spaces."
}

variable "ddos_protection_plan_id" {
  type        = string
  description = "Existing DDoS protection plan ID."
  default     = null
}

variable "subnets" {
  type = map(object({
    address_prefixes                  = list(string)
    network_security_group_id         = optional(string)
    service_endpoints                 = optional(list(string), [])
    private_endpoint_network_policies = optional(string, "Enabled")
  }))
  description = "Subnets keyed by subnet name."
  default     = {}
}

variable "peerings" {
  type = map(object({
    remote_virtual_network_id    = string
    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic      = optional(bool, false)
    allow_gateway_transit        = optional(bool, false)
    use_remote_gateways          = optional(bool, false)
  }))
  description = "Virtual network peerings keyed by peering name."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the virtual network."
  default     = {}
}
