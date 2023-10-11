variable "resource_group" {}
variable "vm_size" {}
variable "nic_id" {}
variable "admin_username" {}
variable "admin_password" {
  sensitive = true
}