
data "azurerm_resource_group" "rg_snbx" {
  name = var.resource_group
}

resource "azurerm_virtual_network" "vnet_snbx" {
  name                = var.virtual_network_name
  location            = data.azurerm_resource_group.rg_snbx.location
  resource_group_name = data.azurerm_resource_group.rg_snbx.name
  address_space       = var.address_range

  tags = {
    environment = var.environment
  }
}

resource "azurerm_subnet" "subnet_snbx" {
    name                 = "subnet-snbx-001"
    resource_group_name = data.azurerm_resource_group.rg_snbx.name
    virtual_network_name = azurerm_virtual_network.vnet_snbx.name
    address_prefix       = "[10.0.2.0/24]"
}

resource "azurerm_network_interface" "nic_snbx" {
  name                = "vnic-snbx-001"
  location            = data.azurerm_resource_group.rg_snbx.location
  resource_group_name = data.azurerm_resource_group.rg_snbx.name

    ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_snbx.id
    private_ip_address_allocation  = "Dynamic"
  }
}
