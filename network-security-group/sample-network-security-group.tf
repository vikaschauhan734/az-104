#Network Security Group
resource "azurerm_network_security_group" "mynsg" {
  name = "mynsg-01"
  location = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

#Network Security Rule
resource "azurerm_network_security_rule" "mynsr" {
  name = "allow_inbound_ssh"
  priority = 100
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "*"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = azurerm_resource_group.myrg.name
  network_security_group_name = azurerm_network_security_group.mynsg.name
}

#Associate Network Interface with NSG
resource "azurerm_network_interface_security_group_association" "mynisga" {
  network_interface_id = azurerm_network_interface.myvmnic.id
  network_security_group_id = azurerm_network_security_group.mynsg.id
}