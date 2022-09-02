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
  name = "demorg1"
  location = "Central India"
}

#Storage Account
resource "azurerm_storage_account" "mysa" {
  name = "demosa773344"
  resource_group_name = azurerm_resource_group.myrg.name
  location = azurerm_resource_group.myrg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

#Storage Container
resource "azurerm_storage_container" "mysc" {
  name = "documents"
  storage_account_name = azurerm_storage_account.mysa.name
  container_access_type = "private"
}

#Storage Blob
resource "azurerm_storage_blob" "mysb" {
  name = "imp-doc"
  storage_account_name = azurerm_storage_account.mysa.name
  storage_container_name = azurerm_storage_container.mysc.name
  type = "Block"
  source = "Vikas's Resume.pdf"
}