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
#Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  name = "myrg-1"
  location = "Central India"
}

#Azure Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  count = 2  
  name = "myvnet-${count.index}"
  address_space = [ "10.0.0.0/16" ]
  location = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

#Azure Virtual Network
resource "azurerm_virtual_network" "myvnet2" {
  name = "myvnet-2"
  address_space = [ "10.0.0.0/16" ]
  location = "West Europe"
  resource_group_name = azurerm_resource_group.myrg.name
}

#Azure Subnet
resource "azurerm_subnet" "mysubnet" {
  count = 2  
  name = "mysubnet-${count.index}"
  resource_group_name = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet[count.index].name
  address_prefixes = [ "10.0.2.0/24" ]
}

#Azure Subnet
resource "azurerm_subnet" "mysubnet2" {
  name = "mysubnet-2"
  resource_group_name = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet2.name
  address_prefixes = [ "10.0.2.0/24" ]
}

#Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  count = 2
  name = "mypublicip-${count.index}"
  resource_group_name = azurerm_resource_group.myrg.name
  location = azurerm_resource_group.myrg.location
  allocation_method = "Static"
}

#Public IP Address
resource "azurerm_public_ip" "mypublicip2" {
  name = "mypublicip-2"
  resource_group_name = azurerm_resource_group.myrg.name
  location = "West Europe"
  allocation_method = "Static"
}

#Network Interface
resource "azurerm_network_interface" "myvmnic" {
  count = 2
  name                = "vmnic-${count.index}"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet[count.index].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = element(azurerm_public_ip.mypublicip[*].id, count.index) 
  }
}

#Network Interface
resource "azurerm_network_interface" "myvmnic2" {
  name                = "vmnic-2"
  location            = "West Europe"
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip2.id 
  }
}

#Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  count = 2
  name = "mylinuxvm-${count.index}"
  computer_name = "vikaschauhanlinux-vm${count.index}" #Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location = azurerm_resource_group.myrg.location
  size = "Standard_DS1_v2"
  admin_username = "azureuser"
  network_interface_ids = [ element(azurerm_network_interface.myvmnic[*].id, count.index) ]
  admin_ssh_key {
    username = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "osdisk${count.index}"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "RedHat"
    offer = "RHEL"
    sku = "83-gen2"
    version = "latest"
  }
}

#Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm2" {
  name = "mylinuxvm-2"
  computer_name = "vikaschauhanlinux-vm2" #Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location = "West Europe"
  size = "Standard_DS1_v2"
  admin_username = "azureuser"
  network_interface_ids = [azurerm_network_interface.myvmnic2.id ]
  admin_ssh_key {
    username = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "osdisk2"
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "RedHat"
    offer = "RHEL"
    sku = "83-gen2"
    version = "latest"
  }
}