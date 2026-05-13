output "windows_vm_ids" {
  value       = { for k, v in azurerm_windows_virtual_machine.this : k => v.id }
  description = "Map of Windows VM IDs"
}

output "linux_vm_ids" {
  value       = { for k, v in azurerm_linux_virtual_machine.this : k => v.id }
  description = "Map of Linux VM IDs"
}

output "vm_nic_ids" {
  value       = { for k, v in azurerm_network_interface.vm : k => v.id }
  description = "Map of Network Interface IDs"
}

output "vm_nic_private_ips" {
  value = {
    for k, v in azurerm_network_interface.vm : k => [
      for config in v.ip_configuration : config.private_ip_address
    ]
  }
  description = "Map of private IP addresses"
}

output "vm_public_ip_addresses" {
  value = {
    for k, v in azurerm_public_ip.vm : k => v.ip_address
  }
  description = "Map of public IP addresses"
}

output "managed_disk_ids" {
  value       = { for k, v in azurerm_managed_disk.vm_data_disks : k => v.id }
  description = "Map of managed disk IDs"
}

output "vm_principal_ids" {
  value = merge(
    { for k, v in azurerm_windows_virtual_machine.this : k => v.identity[0].principal_id },
    { for k, v in azurerm_linux_virtual_machine.this : k => v.identity[0].principal_id }
  )
  description = "Map of VM principal IDs for RBAC assignments"
}
