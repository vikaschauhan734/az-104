#Route Tables
resource "azurerm_route_table" "myrt" {
  name = "myrt-01"
  location = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  disable_bgp_route_propagation = false
  #Define Route
  route {
    name           = "route-01"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "None"
  }
}

#Associate Subnet with Route table
resource "azurerm_subnet_route_table_association" "mysrta" {
  subnet_id      = azurerm_subnet.mysubnet.id
  route_table_id = azurerm_route_table.myrt.id
}