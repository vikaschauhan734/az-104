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
  name = "myvnet-1"
  address_space = [ "10.0.0.0/16" ]
  location = "Central India"
  resource_group_name = azurerm_resource_group.myrg.name
}

#Azure Subnet
resource "azurerm_subnet" "mysubnet" {
  name = "mysubnet-1"
  resource_group_name = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes = [ "10.0.2.0/24" ]
}

#Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  name = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location = "Central India"
  allocation_method = "Static"
}

#Network Interface
resource "azurerm_network_interface" "myvmnic" {
  name                = "vmnic-1"
  location            = "Central India"
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip.id 
  }
}

#Azure VM
resource "azurerm_windows_virtual_machine" "myvm" {
  name = "myvm-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location = azurerm_resource_group.myrg.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.myvmnic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  enable_automatic_updates = true
}

#Network Security Group
resource "azurerm_network_security_group" "mynsg" {
  name = "mynsg-01"
  location = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

#Network Security Rule
resource "azurerm_network_security_rule" "mynsr1" {
  name = "allow_inbound_rdp"
  priority = 100
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "3389"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = azurerm_resource_group.myrg.name
  network_security_group_name = azurerm_network_security_group.mynsg.name
}

#Associate Network Interface with NSG
resource "azurerm_network_interface_security_group_association" "mynisga1" {
  network_interface_id = azurerm_network_interface.myvmnic.id
  network_security_group_id = azurerm_network_security_group.mynsg.id
}

#Network Security Rule
resource "azurerm_network_security_rule" "mynsr2" {
  name = "allow_inbound_http"
  priority = 101
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "80"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = azurerm_resource_group.myrg.name
  network_security_group_name = azurerm_network_security_group.mynsg.name
}

#Network Security Rule
resource "azurerm_network_security_rule" "mynsr3" {
  name = "allow_inbound_https"
  priority = 102
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "443"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = azurerm_resource_group.myrg.name
  network_security_group_name = azurerm_network_security_group.mynsg.name
}



