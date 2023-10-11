

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.98.0"
    }
  }
}

provider "azurerm" {
   skip_provider_registration = true
   features {}
}


output "id" {
  value = data.azurerm_resource_group.example.id
}

// resource "azurerm_storage_account" "lab" {
//   name                     = "sharhan"
//   resource_group_name      = data.azurerm_resource_group.example.name
//   location                 = "East US"
//   account_tier            = "Standard"
//   account_replication_type = "LRS"

//    tags = {
//     environment = "Terraform Storage"
//     CreatedBy = "Admin"
//       }
//   }

resource "azurerm_storage_account" "lab" {
  name                     = "sharhan"
  resource_group_name      = "156-e7b8acea-deploy-an-azure-storage-account-with"
  location                 = "East US"
  account_tier            = "Standard"
  account_replication_type = "LRS"

   tags = {
    environment = "Terraform Storage"
    CreatedBy = "Admin"
      }
  }