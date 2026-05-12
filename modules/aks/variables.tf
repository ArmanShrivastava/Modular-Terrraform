variable "name" { type = string }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tenant_id" { type = string }
variable "dns_prefix" { type = string }
variable "kubernetes_version" { type = string }
variable "node_resource_group" { type = string }
variable "sku_tier" { type = string }
variable "private_cluster_enabled" { type = bool }
variable "private_dns_zone_id" { type = string }
variable "azure_policy_enabled" { type = bool }
variable "oidc_issuer_enabled" { type = bool }
variable "workload_identity_enabled" { type = bool }
variable "local_account_disabled" { type = bool }
variable "service_cidr" { type = string }
variable "dns_service_ip" { type = string }
variable "log_analytics_workspace_id" { type = string }
variable "admin_group_object_ids" {
  type    = list(string)
  default = []
}

variable "default_node_pool" {
  type = object({
    name            = string
    vm_size         = string
    vnet_subnet_id  = string
    zones           = list(string)
    min_count       = number
    max_count       = number
    max_pods        = number
    os_disk_size_gb = number
  })
}

variable "user_node_pools" {
  type = map(object({
    vm_size         = string
    vnet_subnet_id  = string
    zones           = optional(list(string))
    min_count       = number
    max_count       = number
    max_pods        = number
    os_disk_size_gb = number
    node_labels     = optional(map(string), {})
    node_taints     = optional(list(string), [])
  }))
  default = {}
}

variable "tags" {
  type    = map(string)
  default = {}
}
