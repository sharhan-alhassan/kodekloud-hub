
data "azurerm_resource_group" "rg_snbx" {
  name = var.resource_group
}

resource "azurerm_windows_virtual_machine" "vm_snbx" {
  name                = "vm-snbx-001"
  resource_group_name = data.azurerm_resource_group.rg_snbx.name
  location            = data.azurerm_resource_group.rg_snbx.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = var.nic_id

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}