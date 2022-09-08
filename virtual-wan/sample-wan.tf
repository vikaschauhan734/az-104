#Virtual WAN
resource "azurerm_virtual_wan" "mywan" {
  name                = "mywan-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  type = "Standard"
}

#Virtual Hub
resource "azurerm_virtual_hub" "myvhub" {
  name                = "virtualhub-01"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  virtual_wan_id      = azurerm_virtual_wan.mywan.id
  address_prefix      = "10.0.0.0/23"
}