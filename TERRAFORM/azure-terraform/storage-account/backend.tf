terraform {
    backend "azurem" {
        resource_group_name = "TFResourceGroup"
        storage_account_name = "storage4terraform"
        container_name = "statfile"
        key = "terraform.tfstate"
    }
}