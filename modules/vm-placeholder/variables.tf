variable "subscription_id" {
  type        = string
  description = "Azure subscription ID."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group containing the VM."
}

variable "name" {
  type        = string
  description = "Virtual machine name."
}

variable "notes" {
  type        = string
  description = "Migration notes for this existing VM."
  default     = "Import VM, NIC, OS disk, data disks, extensions, and public IPs together before allowing Terraform to change VM settings."
}
