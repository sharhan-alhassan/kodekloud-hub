variable "resource_group" {}
variable "environment" {}
variable "storage_account_name" {}
variable "virtual_network_name" {}
variable "address_range" {}
variable "vm_size" {}
variable "nic_id" {}
variable "admin_username" {}
variable "admin_password" {
  sensitive = true
}
variable "snbx_dlsgen2_name" {}
variable "private_endpoint_name" {}
variable "private_subnet1" {}
variable "public_subnet1" {}
variable "sql_admin" {}
variable "sql_password" {
  sensitive = true
}
