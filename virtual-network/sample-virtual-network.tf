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
  name     = "myrg-1"
  location = "Central India"
}

#Virtual Network
resource "azurerm_virtual_network" "myvn" {
  name                = "vnet-demo-01"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "default"
    address_prefix = "10.0.0.0/24"
  }

}