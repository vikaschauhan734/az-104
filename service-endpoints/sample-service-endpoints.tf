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
  name     = "myrg-01"
  location = "Central India"
}

#Subnet Service Endpoint Storage Policy
resource "azurerm_subnet_service_endpoint_storage_policy" "myssesp" {
  name                = "myssesp-01"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  definition {
    name        = "name1"
    description = "definition1"
    service_resources = [
      azurerm_resource_group.myrg.id,
      azurerm_storage_account.mysa.id
    ]
  }
}

#Storage Account
resource "azurerm_storage_account" "mysa" {
  name                     = "mysaccount99595223"
  resource_group_name      = azurerm_resource_group.myrg.name
  location                 = azurerm_resource_group.myrg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}