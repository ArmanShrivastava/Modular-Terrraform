variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "network_security_groups" {
  type = map(object({
    name = string
    inbound_rules = optional(list(object({
      name                        = string
      priority                    = optional(number)
      access                      = string # Allow or Deny
      protocol                    = string # TCP, UDP, ICMP, *
      source_port_range           = optional(string)
      source_port_ranges          = optional(list(string))
      destination_port_range      = optional(string)
      destination_port_ranges     = optional(list(string))
      source_address_prefix       = optional(string)
      source_address_prefixes     = optional(list(string))
      destination_address_prefix  = optional(string)
      destination_address_prefixes = optional(list(string))
    })), [])
    outbound_rules = optional(list(object({
      name                        = string
      priority                    = optional(number)
      access                      = string # Allow or Deny
      protocol                    = string # TCP, UDP, ICMP, *
      source_port_range           = optional(string)
      source_port_ranges          = optional(list(string))
      destination_port_range      = optional(string)
      destination_port_ranges     = optional(list(string))
      source_address_prefix       = optional(string)
      source_address_prefixes     = optional(list(string))
      destination_address_prefix  = optional(string)
      destination_address_prefixes = optional(list(string))
    })), [])
    additional_tags = optional(map(string), {})
  }))
  description = "Map of network security groups with their rules"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply to all resources"
  default     = {}
}
