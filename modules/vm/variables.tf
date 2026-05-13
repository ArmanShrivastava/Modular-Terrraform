variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "create_windows_vms" {
  type        = bool
  description = "Whether to create Windows VMs"
  default     = false
}

variable "create_linux_vms" {
  type        = bool
  description = "Whether to create Linux VMs"
  default     = false
}

variable "virtual_machines" {
  type = map(object({
    name                            = string
    vm_size                         = string
    subnet_id                       = string
    admin_username                  = string
    admin_password                  = optional(string)
    admin_ssh_keys                  = optional(list(object({
      username   = string
      public_key = string
    })), [])
    os_disk_type                    = optional(string, "Premium_LRS")
    os_disk_caching                 = optional(string, "ReadWrite")
    source_image_reference          = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }))
    source_image_id                 = optional(string)
    network_interface_name          = optional(string)
    nic_ip_config_name              = optional(string)
    create_public_ip                = optional(bool, false)
    public_ip_name                  = optional(string)
    public_ip_allocation            = optional(string, "Static")
    public_ip_sku                   = optional(string, "Standard")
    private_ip_allocation           = optional(string, "Dynamic")
    private_ip_address              = optional(string)
    enable_accelerated_networking   = optional(bool, false)
    network_security_group_id       = optional(string)
    identity_type                   = optional(string, "SystemAssigned")
    identity_ids                    = optional(list(string), [])
    disable_password_authentication = optional(bool, true)
    data_disks                      = optional(list(object({
      name                 = optional(string)
      size_gb              = optional(number, 128)
      storage_account_type = optional(string, "Premium_LRS")
      create_option        = optional(string, "Empty")
      lun                  = optional(number)
      caching              = optional(string, "ReadWrite")
    })), [])
    extensions = optional(list(object({
      name                 = string
      publisher            = string
      type                 = string
      type_handler_version = string
      settings             = optional(string)
      protected_settings   = optional(string)
    })), [])
    additional_tags = optional(map(string), {})
  }))
  description = "Map of virtual machines to create"
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply to all resources"
  default     = {}
}
