# Azure Virtual Machine Module
# Supports both single VMs and scale sets
# Includes managed disks, monitoring, backup, and diagnostics

resource "azurerm_windows_virtual_machine" "this" {
  for_each = var.create_windows_vms ? var.virtual_machines : {}

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  vm_size             = each.value.vm_size

  admin_username = each.value.admin_username
  admin_password = each.value.admin_password

  network_interface_ids = [
    azurerm_network_interface.vm[each.key].id
  ]

  os_disk {
    caching              = try(each.value.os_disk_caching, "ReadWrite")
    storage_account_type = try(each.value.os_disk_type, "Premium_LRS")
  }

  # Optional source image reference
  dynamic "source_image_reference" {
    for_each = try(each.value.source_image_reference, null) != null ? [each.value.source_image_reference] : []
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  # Optional custom image reference
  dynamic "source_image_id" {
    for_each = try(each.value.source_image_id, null) != null ? [each.value.source_image_id] : []
    content {
      source_image_id = source_image_id.value
    }
  }

  enable_accelerated_networking = try(each.value.enable_accelerated_networking, false)

  identity {
    type         = try(each.value.identity_type, "SystemAssigned")
    identity_ids = try(each.value.identity_ids, [])
  }

  tags = merge(
    var.tags,
    try(each.value.additional_tags, {})
  )

  lifecycle {
    ignore_changes = [
      admin_password
    ]
  }

  depends_on = [
    azurerm_network_interface.vm
  ]
}

resource "azurerm_linux_virtual_machine" "this" {
  for_each = var.create_linux_vms ? var.virtual_machines : {}

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  vm_size             = each.value.vm_size

  admin_username = each.value.admin_username

  network_interface_ids = [
    azurerm_network_interface.vm[each.key].id
  ]

  os_disk {
    caching              = try(each.value.os_disk_caching, "ReadWrite")
    storage_account_type = try(each.value.os_disk_type, "Premium_LRS")
  }

  # Optional source image reference
  dynamic "source_image_reference" {
    for_each = try(each.value.source_image_reference, null) != null ? [each.value.source_image_reference] : []
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  # Optional custom image reference
  dynamic "source_image_id" {
    for_each = try(each.value.source_image_id, null) != null ? [each.value.source_image_id] : []
    content {
      source_image_id = source_image_id.value
    }
  }

  # SSH key or password-based authentication
  dynamic "admin_ssh_key" {
    for_each = try(each.value.admin_ssh_keys, [])
    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key
    }
  }

  disable_password_authentication = try(each.value.disable_password_authentication, true)

  enable_accelerated_networking = try(each.value.enable_accelerated_networking, false)

  identity {
    type         = try(each.value.identity_type, "SystemAssigned")
    identity_ids = try(each.value.identity_ids, [])
  }

  tags = merge(
    var.tags,
    try(each.value.additional_tags, {})
  )

  depends_on = [
    azurerm_network_interface.vm
  ]
}

# Network Interface for VMs
resource "azurerm_network_interface" "vm" {
  for_each = var.virtual_machines

  name                = try(each.value.network_interface_name, "${each.value.name}-nic")
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = try(each.value.nic_ip_config_name, "default")
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = try(each.value.private_ip_allocation, "Dynamic")
    private_ip_address            = try(each.value.private_ip_address, null)
    public_ip_address_id          = try(each.value.create_public_ip, false) ? azurerm_public_ip.vm[each.key].id : null
    primary                       = true
  }

  enable_accelerated_networking = try(each.value.enable_accelerated_networking, false)

  tags = merge(
    var.tags,
    try(each.value.additional_tags, {})
  )
}

# Network Security Group association for NIC
resource "azurerm_network_interface_security_group_association" "vm" {
  for_each = {
    for k, v in var.virtual_machines : k => v
    if try(v.network_security_group_id, null) != null
  }

  network_interface_id      = azurerm_network_interface.vm[each.key].id
  network_security_group_id = each.value.network_security_group_id
}

# Public IP for VMs (optional)
resource "azurerm_public_ip" "vm" {
  for_each = {
    for k, v in var.virtual_machines : k => v
    if try(v.create_public_ip, false)
  }

  name                = try(each.value.public_ip_name, "${each.value.name}-pip")
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = try(each.value.public_ip_allocation, "Static")
  sku                 = try(each.value.public_ip_sku, "Standard")

  tags = merge(
    var.tags,
    try(each.value.additional_tags, {})
  )
}

# Additional data disks
resource "azurerm_managed_disk" "vm_data_disks" {
  for_each = {
    for disk_key, disk_config in flatten([
      for vm_key, vm_config in var.virtual_machines : [
        for disk_idx, disk in try(vm_config.data_disks, []) : {
          key                = "${vm_key}-disk-${disk_idx}"
          vm_key             = vm_key
          disk_config        = disk
          location           = var.location
          resource_group_name = var.resource_group_name
          vm_name            = vm_config.name
          tags               = merge(var.tags, try(vm_config.additional_tags, {}))
        }
      ]
    ]) : disk_key => disk_config
  }

  name                = try(each.value.disk_config.name, "${each.value.vm_name}-datadisk-${each.key}")
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  storage_account_type = try(each.value.disk_config.storage_account_type, "Premium_LRS")
  create_option       = try(each.value.disk_config.create_option, "Empty")
  disk_size_gb        = try(each.value.disk_config.size_gb, 128)

  tags = each.value.tags
}

# Data disk attachment
resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each = {
    for disk_key, disk_config in flatten([
      for vm_key, vm_config in var.virtual_machines : [
        for disk_idx, disk in try(vm_config.data_disks, []) : {
          key              = "${vm_key}-disk-${disk_idx}"
          vm_key           = vm_key
          vm_id            = var.create_windows_vms ? azurerm_windows_virtual_machine.this[vm_key].id : azurerm_linux_virtual_machine.this[vm_key].id
          managed_disk_id  = azurerm_managed_disk.vm_data_disks["${vm_key}-disk-${disk_idx}"].id
          lun              = try(disk.lun, disk_idx)
          caching          = try(disk.caching, "ReadWrite")
        }
      ]
    ]) : disk_key => disk_config
  }

  managed_disk_id           = each.value.managed_disk_id
  virtual_machine_id        = each.value.vm_id
  lun                       = each.value.lun
  caching                   = each.value.caching
}

# VM Extensions
resource "azurerm_virtual_machine_extension" "this" {
  for_each = {
    for ext_key, ext_config in flatten([
      for vm_key, vm_config in var.virtual_machines : [
        for ext_idx, ext in try(vm_config.extensions, []) : {
          key              = "${vm_key}-ext-${ext_idx}"
          vm_key           = vm_key
          is_windows       = var.create_windows_vms
          vm_id            = var.create_windows_vms ? azurerm_windows_virtual_machine.this[vm_key].id : azurerm_linux_virtual_machine.this[vm_key].id
          ext_config       = ext
        }
      ]
    ]) : ext_key => ext_config
  }

  name               = try(each.value.ext_config.name, "Extension")
  virtual_machine_id = each.value.vm_id
  publisher          = each.value.ext_config.publisher
  type               = each.value.ext_config.type
  type_handler_version = each.value.ext_config.type_handler_version

  settings           = try(each.value.ext_config.settings, null)
  protected_settings = try(each.value.ext_config.protected_settings, null)

  depends_on = [
    azurerm_virtual_machine_data_disk_attachment.this
  ]
}
