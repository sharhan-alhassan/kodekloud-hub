
output "storage_account_name" {
    value = azurerm_storage_account.sa_snbx.id
}

output "datalake_storage" {
  value = azurerm_storage_data_lake_gen2_filesystem.adlsgen2_snbx.id
}

output "private_endpint_fqdn" {
  value = azurerm_private_endpoint.snbx_private_endpoint.private_dns_zone_configs
}