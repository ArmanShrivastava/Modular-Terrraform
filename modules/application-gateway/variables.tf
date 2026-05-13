variable "name" {
  type        = string
  description = "Application Gateway name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "sku_name" {
  type        = string
  description = "SKU name (Standard_v2, WAF_v2, etc.)"
  default     = "Standard_v2"
}

variable "sku_tier" {
  type        = string
  description = "SKU tier (Standard, WAF, etc.)"
  default     = "Standard_v2"
}

variable "capacity" {
  type        = number
  description = "Capacity"
  default     = 2
}

variable "gateway_ip_config_name" {
  type        = string
  description = "Gateway IP configuration name"
  default     = "gateway-ip-config"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the Application Gateway"
}

variable "frontend_ports" {
  type = list(object({
    name = string
    port = number
  }))
  description = "Frontend ports configuration"
  default = [
    {
      name = "http"
      port = 80
    },
    {
      name = "https"
      port = 443
    }
  ]
}

variable "frontend_ip_config_name" {
  type        = string
  description = "Frontend IP configuration name"
  default     = "appgw-frontend-ip"
}

variable "public_ip_address_id" {
  type        = string
  description = "Public IP address ID for frontend"
  default     = ""
}

variable "private_ip_allocation" {
  type        = string
  description = "Private IP allocation method (Static or Dynamic)"
  default     = null
}

variable "private_ip_address" {
  type        = string
  description = "Private IP address (when using Static allocation)"
  default     = null
}

variable "private_subnet_id" {
  type        = string
  description = "Private subnet ID (for private frontend)"
  default     = null
}

variable "backend_pools" {
  type = list(object({
    name         = string
    fqdns        = optional(list(string))
    ip_addresses = optional(list(string))
  }))
  description = "Backend address pools"
}

variable "backend_http_settings" {
  type = list(object({
    name                                    = string
    cookie_based_affinity                   = optional(string, "Disabled")
    port                                    = number
    protocol                                = string # HTTP or HTTPS
    request_timeout                         = optional(number, 30)
    host_name                               = optional(string)
    pick_host_name_from_backend_address    = optional(bool, false)
    connection_draining = optional(object({
      enabled           = bool
      drain_timeout_sec = optional(number, 300)
    }))
    authentication_certificates = optional(list(object({
      name = string
    })), [])
    trusted_root_certificate_names = optional(list(string))
  }))
  description = "Backend HTTP settings"
}

variable "http_listeners" {
  type = list(object({
    name                = string
    frontend_port_name  = string
    protocol            = string # HTTP or HTTPS
    host_names          = optional(list(string))
    require_sni         = optional(bool, false)
    ssl_certificate_name = optional(string)
    ssl_profile_name    = optional(string)
    firewall_policy_id  = optional(string)
  }))
  description = "HTTP listeners"
}

variable "request_routing_rules" {
  type = list(object({
    name                       = string
    rule_type                  = optional(string, "Basic")
    http_listener_name         = string
    backend_address_pool_name  = optional(string)
    backend_http_settings_name = optional(string)
    redirect_configuration_name = optional(string)
    rewrite_rule_set_name      = optional(string)
    url_path_map_name          = optional(string)
    priority                   = optional(number)
  }))
  description = "Request routing rules"
}

variable "ssl_certificates" {
  type = list(object({
    name                = string
    data                = optional(string)
    password            = optional(string)
    key_vault_secret_id = optional(string)
  }))
  description = "SSL certificates"
  default     = []
}

variable "ssl_policy" {
  type = object({
    disabled_protocols   = optional(list(string))
    policy_type          = optional(string)
    policy_name          = optional(string)
    min_protocol_version = optional(string)
    cipher_suites        = optional(list(string))
  })
  description = "SSL policy configuration"
  default     = null
}

variable "redirect_configurations" {
  type = list(object({
    name                 = string
    redirect_type        = string
    target_listener_name = optional(string)
    target_url           = optional(string)
    include_path         = optional(bool, true)
    include_query_string = optional(bool, true)
  }))
  description = "Redirect configurations"
  default     = []
}

variable "enable_http2" {
  type        = bool
  description = "Enable HTTP/2 support"
  default     = false
}

variable "enable_fips" {
  type        = bool
  description = "Enable FIPS mode"
  default     = false
}

variable "force_firewall_policy_association" {
  type        = bool
  description = "Force firewall policy association"
  default     = false
}

variable "enable_autoscaling" {
  type        = bool
  description = "Enable autoscaling"
  default     = false
}

variable "autoscale_min_capacity" {
  type        = number
  description = "Minimum autoscale capacity"
  default     = 1
}

variable "autoscale_max_capacity" {
  type        = number
  description = "Maximum autoscale capacity"
  default     = 10
}

variable "autoscale_default_capacity" {
  type        = number
  description = "Default autoscale capacity"
  default     = 2
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default     = {}
}

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags"
  default     = {}
}
