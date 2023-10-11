variable "resource_group" {}
variable "storage_account_name" {}
variable "sql_admin" {}
variable "sql_password" {
    sensitive = true
}
variable "environment" {}
