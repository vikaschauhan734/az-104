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
#Source Resource Group
resource "azurerm_resource_group" "myrgsrc" {
  name     = "myrg1"
  location = "Central India"
}

#Source Storage Account
resource "azurerm_storage_account" "mysasrc" {
  name                     = "srcstorageaccount121"
  resource_group_name      = azurerm_resource_group.myrgsrc.name
  location                 = azurerm_resource_group.myrgsrc.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  blob_properties {
    versioning_enabled  = true
    change_feed_enabled = true
  }
}

#Source Storage Container
resource "azurerm_storage_container" "myscsrc" {
  name                  = "srcstrcontainer"
  storage_account_name  = azurerm_storage_account.mysasrc.name
  container_access_type = "private"
}

#Destination Resource Group
resource "azurerm_resource_group" "myrgdst" {
  name     = "myrg2"
  location = "West India"
}

#Destination Storage Account
resource "azurerm_storage_account" "mysadst" {
  name                     = "dststorageaccount121"
  resource_group_name      = azurerm_resource_group.myrgdst.name
  location                 = azurerm_resource_group.myrgdst.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  blob_properties {
    versioning_enabled  = true
    change_feed_enabled = true
  }
}

#Destination Storage Container
resource "azurerm_storage_container" "myscdst" {
  name                  = "dststrcontainer"
  storage_account_name  = azurerm_storage_account.mysadst.name
  container_access_type = "private"
}

#Storage Object Replication
resource "azurerm_storage_object_replication" "document" {
  source_storage_account_id      = azurerm_storage_account.mysasrc.id
  destination_storage_account_id = azurerm_storage_account.mysadst.id
  rules {
    source_container_name      = azurerm_storage_container.myscsrc.name
    destination_container_name = azurerm_storage_container.myscdst.name
  }
}