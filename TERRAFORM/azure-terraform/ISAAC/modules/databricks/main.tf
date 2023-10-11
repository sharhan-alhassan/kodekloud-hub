
data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg_snbx" {
  name = var.resource_group
}

data "azurerm_key_vault" "key_vault_snbx" {
  name                = "snbx-kv-001"
  resource_group_name = data.azurerm_resource_group.rg_snbx.name
}

resource "azurerm_databricks_workspace" "dbricks_snbx" {
  name                = "dbricks-snbx-001"
  resource_group_name = data.azurerm_resource_group.rg_snbx.name
  location            = data.azurerm_resource_group.rg_snbx.location
  sku                 = "premium"

  customer_managed_key_enabled = true

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_databricks_workspace_customer_managed_key" "dbricks_key_snbx" {
  workspace_id     = azurerm_databricks_workspace.dbricks_snbx.id
  key_vault_key_id = data.azurerm_key_vault.key_vault_snbx.id
}