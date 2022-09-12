#Azure Subnet
resource "azurerm_subnet" "mysubnet2" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "mypip" {
  name                = "mypip-2"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "myash" {
  name                = "mybastion"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.mysubnet2.id
    public_ip_address_id = azurerm_public_ip.mypip.id
  }
}