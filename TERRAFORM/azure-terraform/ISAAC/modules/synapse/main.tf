data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg_snbx" {
  name = var.resource_group
}

data "azurerm_storage_account" "sa_snbx" {
  name = var.storage_account_name
}

data "azurerm_storage_data_lake_gen2_filesystem" "sa_snbx" {
  name = "snbx-dlsgen2-001"
  storage_account_id = data.azurerm_storage_account.sa_snbx.id
}

data "azurerm_key_vault" "key_vault_snbx" {
  name                = "snbx-kv-001"
  resource_group_name = data.azurerm_resource_group.rg_snbx.name
}

resource "azurerm_synapse_workspace" "synapse_worksapce01" {
  name                                 = "snbx-workspace-001"
  resource_group_name                  = data.azurerm_resource_group.rg_snbx.name
  location                             = data.azurerm_resource_group.rg_snbx.location
  storage_data_lake_gen2_filesystem_id = data.azurerm_storage_data_lake_gen2_filesystem.sa_snbx.id
  sql_administrator_login              = var.sql_admin
  sql_administrator_login_password     = var.sql_password
  customer_managed_key {
    key_versionless_id = data.azurerm_key_vault.key_vault_snbx.versionless_id
    key_name           = "masterKeY"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Env = var.environment
  }
}