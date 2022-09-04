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
  name                     = "azureteststorage121"
  resource_group_name      = azurerm_resource_group.myrg.name
  location                 = azurerm_resource_group.myrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#File Share
resource "azurerm_storage_share" "myss" {
  name                 = "sharename1"
  storage_account_name = azurerm_storage_account.mysa.name
  quota                = 50
}

#Upload file
resource "azurerm_storage_share_file" "myssf" {
  name             = "Vikas's Resume.pdf"
  storage_share_id = azurerm_storage_share.myss.id
  source           = "Vikas's Resume.pdf"
}