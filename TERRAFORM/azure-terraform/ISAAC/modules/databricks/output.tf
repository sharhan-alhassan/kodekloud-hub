
output "databricks_workspace_id" {
  value = azurerm_databricks_workspace.dbricks_snbx.i
}

output "vault_uri" {
  value = data.azurerm_key_vault.key_vault_snbx.vault_uri
}