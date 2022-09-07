#Create Subnet
resource "azurerm_subnet" "mysnet" {
  name = "AzureFirewallSubnet"
  resource_group_name = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes = [ "10.0.1.0/26" ]
}

#Public IP Address
resource "azurerm_public_ip" "mypip" {
  name = "mypublicip-2"
  resource_group_name = azurerm_resource_group.myrg.name
  location = azurerm_resource_group.myrg.location
  allocation_method = "Static"
  domain_name_label = "app1-vm-11${random_string.myrandom.id}"
}

#Azure Firewall
resource "azurerm_firewall" "myfw" {
  name                = "myfw-01"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.mysnet.id
    public_ip_address_id = azurerm_public_ip.mypip.id
  }
}

#Route Tables
resource "azurerm_route_table" "myrt" {
  name = "myrtfw-01"
  location = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  disable_bgp_route_propagation = false
  #Define Route
  route {
    name           = "route-01"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Virtual Appliance"
    next_hop_in_ip_address = azurerm_public_ip.mypip.ip_address
  }
}

#Associate Subnet with Route table
resource "azurerm_subnet_route_table_association" "mysrta" {
  subnet_id      = azurerm_subnet.mysubnet.id
  route_table_id = azurerm_route_table.myrt.id
}

#Azure Firewall NAT Rule
resource "azurerm_firewall_nat_rule_collection" "myfwnatr" {
  name                = "natcollection"
  azure_firewall_name = azurerm_firewall.myfw.name
  resource_group_name = azurerm_resource_group.myrg.name
  priority            = 100
  action              = "Dnat"

  rule {
    name = "ssh"
    source_addresses = ["*"]
    destination_ports = ["22"]
    destination_addresses = [azurerm_public_ip.myfw.ip_address]
    translated_port = 22
    translated_address = "10.0.0.4"
    protocols = ["TCP"]
  }
}
