#Terraform Block
terraform {
  required_version = "> 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0"
     }
  }
}

#Provider Block
provider "azurerm" {
  features {}
}

#Resource Block
#Resource Group
resource "azurerm_resource_group" "myrg" {
  name     = "myrg1"
  location = "Central India"
}

#Storage Account
resource "azurerm_storage_account" "mysa" {
  name = "mysablm"
  resource_group_name = azurerm_resource_group.myrg.name
  location = azurerm_resource_group.myrg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
  account_kind = "BlobStorage"
}

#Storage Management Policy
resource "azurerm_storage_management_policy" "mysmp" {
  storage_account_id = azurerm_storage_account.mysa.id
  rule {
    name    = "rule1"
    enabled = true
    filters {
      prefix_match = ["container1/prefix1"]
      blob_types   = ["blockBlob"]
      match_blob_index_tag {
        name      = "tag1"
        operation = "=="
        value     = "val1"
      }
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 10
        tier_to_archive_after_days_since_modification_greater_than = 50
        delete_after_days_since_modification_greater_than          = 100
      }
      snapshot {
        delete_after_days_since_creation_greater_than = 30
      }
    }
  }
  rule {
    name    = "rule2"
    enabled = false
    filters {
      prefix_match = ["container2/prefix1", "container2/prefix2"]
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        tier_to_cool_after_days_since_modification_greater_than    = 11
        tier_to_archive_after_days_since_modification_greater_than = 51
        delete_after_days_since_modification_greater_than          = 101
      }
      snapshot {
        change_tier_to_archive_after_days_since_creation = 90
        change_tier_to_cool_after_days_since_creation    = 23
        delete_after_days_since_creation_greater_than    = 31
      }
      version {
        change_tier_to_archive_after_days_since_creation = 9
        change_tier_to_cool_after_days_since_creation    = 90
        delete_after_days_since_creation                 = 3
      }
    }
  }
}
