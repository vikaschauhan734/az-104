#Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "myvng" {
  name                = "azure-vng"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  type     = "Vpn"
  vpn_type = "RouteBased"
  active_active = false
  enable_bgp    = false
  sku           = "VpnGw2"
  ip_configuration {
    name = "vnetGatewayConfig"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.mypublicip1.id
    subnet_id = azurerm_subnet.mysubnet2.id
  } 
}