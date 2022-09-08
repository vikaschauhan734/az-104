#VNet Peering vnet0 to vnet1
resource "azurerm_virtual_network_peering" "myvp01" {
  name                      = "vnet0to1"
  resource_group_name       = azurerm_resource_group.myrg.name
  virtual_network_name      = azurerm_virtual_network.myvnet0.name
  remote_virtual_network_id = azurerm_virtual_network.myvnet1.id
}

#VNet Peering vnet1 to vnet0
resource "azurerm_virtual_network_peering" "myvp10" {
  name                      = "vnet1to0"
  resource_group_name       = azurerm_resource_group.myrg.name
  virtual_network_name      = azurerm_virtual_network.myvnet1.name
  remote_virtual_network_id = azurerm_virtual_network.myvnet0.id
}

#VNet Peering vnet2 to vnet1
resource "azurerm_virtual_network_peering" "myvp21" {
  name                      = "vnet2to1"
  resource_group_name       = azurerm_resource_group.myrg.name
  virtual_network_name      = azurerm_virtual_network.myvnet2.name
  remote_virtual_network_id = azurerm_virtual_network.myvnet1.id
}

#VNet Peering vnet1 to vnet2
resource "azurerm_virtual_network_peering" "myvp12" {
  name                      = "vnet1to2"
  resource_group_name       = azurerm_resource_group.myrg.name
  virtual_network_name      = azurerm_virtual_network.myvnet1.name
  remote_virtual_network_id = azurerm_virtual_network.myvnet2.id
}

#VNet Peering vnet0 to vnet2
resource "azurerm_virtual_network_peering" "myvp02" {
  name                      = "vnet0to2"
  resource_group_name       = azurerm_resource_group.myrg.name
  virtual_network_name      = azurerm_virtual_network.myvnet0.name
  remote_virtual_network_id = azurerm_virtual_network.myvnet2.id
}

#VNet Peering vnet2 to vnet0
resource "azurerm_virtual_network_peering" "myvp20" {
  name                      = "vnet2to0"
  resource_group_name       = azurerm_resource_group.myrg.name
  virtual_network_name      = azurerm_virtual_network.myvnet2.name
  remote_virtual_network_id = azurerm_virtual_network.myvnet0.id
}