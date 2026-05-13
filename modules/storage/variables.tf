variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "storage_accounts" {
  type = map(object({
    name                           = string
    account_tier                   = optional(string, "Standard")
    account_replication_type       = optional(string, "GRS")
    access_tier                    = optional(string, "Hot")
    https_traffic_only_enabled     = optional(bool, true)
    min_tls_version                = optional(string, "TLS1_2")
    public_network_access_enabled  = optional(bool, true)
    shared_access_key_enabled      = optional(bool, true)
    default_to_oauth_authentication = optional(bool, false)
    prevent_destroy                = optional(bool, true)
    
    network_rules = optional(object({
      default_action             = string
      bypass                     = optional(list(string), ["AzureServices"])
      virtual_network_subnet_ids = optional(list(string), [])
      ip_rules                   = optional(list(string), [])
    }))

    blob_properties = optional(object({
      change_feed_enabled              = optional(bool, false)
      change_feed_retention_in_days    = optional(number, 7)
      default_service_version          = optional(string)
      last_access_time_enabled         = optional(bool, false)
      versioning_enabled               = optional(bool, false)
      delete_retention_policy = optional(object({
        days = optional(number, 7)
      }))
      container_delete_retention_policy = optional(object({
        days = optional(number, 7)
      }))
    }))

    containers = optional(list(object({
      name        = string
      access_type = optional(string, "private")
    })), [])

    file_shares = optional(list(object({
      name             = string
      quota            = optional(number, 100)
      enabled_protocol = optional(string, "SMB")
    })), [])

    queues = optional(list(object({
      name = string
    })), [])

    tables = optional(list(object({
      name = string
    })), [])

    additional_tags = optional(map(string), {})
  }))
  description = "Map of storage accounts to create with containers, shares, queues, and tables"
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply to all resources"
  default     = {}
}
