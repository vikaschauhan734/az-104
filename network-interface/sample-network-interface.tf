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
}

#Subnet
resource "azurerm_subnet" "mysnet" {
    name           = "default"
    address_prefixes = ["10.0.0.0/24"]
    virtual_network_name = azurerm_virtual_network.myvn.name
    resource_group_name = azurerm_resource_group.myrg.name
}

#Network Interface
resource "azurerm_network_interface" "mynic" {
  name                = "mynic-01"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Public IP Address
resource "azurerm_public_ip" "mypip" {
  name = "mypip-01"
  location = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  allocation_method = "Static"
}