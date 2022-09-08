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
resource "azurerm_virtual_network" "myvnet0" {
  name = "myvnet-0"
  address_space = [ "10.0.0.0/16" ]
  location = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

#Azure Virtual Network
resource "azurerm_virtual_network" "myvnet1" {
  name = "myvnet-1"
  address_space = [ "192.168.0.0/16" ]
  location = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

#Azure Virtual Network
resource "azurerm_virtual_network" "myvnet2" {
  name = "myvnet-2"
  address_space = [ "172.16.0.0/16" ]
  location = "West Europe"
  resource_group_name = azurerm_resource_group.myrg.name
}

#Azure Subnet
resource "azurerm_subnet" "mysubnet0" {
  name = "mysubnet-0"
  resource_group_name = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet0.name
  address_prefixes = [ "10.0.2.0/24" ]
}

#Azure Subnet
resource "azurerm_subnet" "mysubnet1" {
  name = "mysubnet-1"
  resource_group_name = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet1.name
  address_prefixes = [ "192.168.2.0/24" ]
}

#Azure Subnet
resource "azurerm_subnet" "mysubnet2" {
  name = "mysubnet-2"
  resource_group_name = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet2.name
  address_prefixes = [ "172.16.2.0/24" ]
}

#Public IP Address
resource "azurerm_public_ip" "mypublicip0" {
  name = "mypublicip-0"
  resource_group_name = azurerm_resource_group.myrg.name
  location = "Central India"
  allocation_method = "Static"
}

#Public IP Address
resource "azurerm_public_ip" "mypublicip1" {
  name = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location = "Central India"
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
resource "azurerm_network_interface" "myvmnic0" {
  name                = "vmnic-0"
  location            = "Central India"
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet0.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip0.id 
  }
}

#Network Interface
resource "azurerm_network_interface" "myvmnic1" {
  name                = "vmnic-1"
  location            = "Central India"
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip1.id 
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
resource "azurerm_linux_virtual_machine" "mylinuxvm0" {
  name = "mylinuxvm-0"
  computer_name = "vikaschauhanlinux-vm0" #Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location = "Central India"
  size = "Standard_DS1_v2"
  admin_username = "azureuser"
  network_interface_ids = [azurerm_network_interface.myvmnic0.id ]
  admin_ssh_key {
    username = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "osdisk0"
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
resource "azurerm_linux_virtual_machine" "mylinuxvm1" {
  name = "mylinuxvm-1"
  computer_name = "vikaschauhanlinux-vm1" #Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location = "Central India"
  size = "Standard_DS1_v2"
  admin_username = "azureuser"
  network_interface_ids = [azurerm_network_interface.myvmnic1.id ]
  admin_ssh_key {
    username = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name = "osdisk1"
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