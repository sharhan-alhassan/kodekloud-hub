
module "data_lake_storage" {
    source = "./modules/data_lake_storage"
    storage_account_name = var.storage_account_name
    environment = var.environment
}

module "virtual_network" {
    source = "./modules/virtual_network"
    virtual_network_name = var.virtual_network_name
    address_range = var.address_range
}

module "vm" {
    source = "./modules/vm"
    vm_size = var.vm_size
    admin_username = var.admin_username
    admin_password = var.admin_password
    network_interface_ids = module.virtual_network.nic_id
}

module "databricks" {
    source = "./modules/databricks"
    environment = var.environment
}

module "synapse" {
  source = "./module/synapse"
  sql_admin = var.sql_admin
  sql_password = var.sql_password
}