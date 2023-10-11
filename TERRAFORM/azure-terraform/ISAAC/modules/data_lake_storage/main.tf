
data "azurerm_resource_group" "rg_snbx" {
  name = var.resource_group
}

data "azurerm_virtual_network" "vnet_snbx" {
  name = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.rg_snbx.name
}

data "azurerm_subnet" "private_subnet1" {
  name                 = var.private_subnet1
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg_snbx.name
}

data "azurerm_subnet" "public_subnet1" {
  name                 = var.public_subnet1
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg_snbx.name
}

resource "azurerm_storage_account" "sa_snbx" {
  name                     = var.storage_account_name
  resource_group_name      = data.azurerm_resource_group.rg_snbx.name
  location                 = data.azurerm_resource_group.rg_snbx.location
  account_tier            = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"

   tags = {
    environment = var.environment
    }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "adlsgen2_snbx" {
  name               = var.snbx_dlsgen2_name
  storage_account_id = azurerm_storage_account.sa_snbx.id

  properties = {
    keys = ""
  }
}

resource "azurerm_public_ip" "snbx_pubip" {
  name                = "example-pip"
  sku                 = "Standard"
  location            = data.azurerm_resource_group.rg_snbx.location
  resource_group_name = data.azurerm_resource_group.rg_snbx.name
  allocation_method   = "Static"
}

resource "azurerm_lb" "snbx_lb" {
  name                = "snbx-lb-001"
  sku                 = "Standard"
  location            = data.azurerm_resource_group.rg_snbx.location
  resource_group_name = data.azurerm_resource_group.rg_snbx.name

  frontend_ip_configuration {
    name                 = azurerm_public_ip.snbx_pubip.name
    public_ip_address_id = azurerm_public_ip.snbx_pubip.id
  }
}

resource "azurerm_private_link_service" "snbx_pl_service" {
  name                = "snbx-privatelink-001"
  location            = data.azurerm_resource_group.rg_snbx.location
  resource_group_name = data.azurerm_resource_group.rg_snbx.name

  nat_ip_configuration {
    name      = azurerm_public_ip.snbx_pubip.name
    primary   = true
    subnet_id = data.azurerm_subnet.private_subnet1.id
  }

  load_balancer_frontend_ip_configuration_ids = [
    azurerm_lb.example.frontend_ip_configuration.0.id,
  ]
}

resource "azurerm_private_endpoint" "snbx_private_endpoint" {
  name                = var.private_endpoint_name
  location            = data.azurerm_resource_group.rg_snbx.location
  resource_group_name = data.azurerm_resource_group.rg_snbx.name
  subnet_id           = data.azurerm_subnet.private_subnet1.id

  private_service_connection {
    name                              = "snbx-private-service-001"
    private_connection_resource_id = azurerm_private_link_service.snbx_pl_service.id
    is_manual_connection              = true
    request_message                   = "PL"
    subresource_names = [ "dfs", "blob" ]
  }
}