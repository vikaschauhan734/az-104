#Network Security Group
resource "azurerm_network_security_group" "mynsg1" {
  name = "mynsg-01"
  location = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

#Network Security Group
resource "azurerm_network_security_group" "mynsg2" {
  name = "mynsg-02"
  location = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}

#Network Security Rule
resource "azurerm_network_security_rule" "mynsr1" {
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
  network_security_group_name = azurerm_network_security_group.mynsg1.name
}

#Network Security Rule
resource "azurerm_network_security_rule" "mynsr2" {
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
  network_security_group_name = azurerm_network_security_group.mynsg2.name
}


#Associate Network Interface with NSG
resource "azurerm_network_interface_security_group_association" "mynisga1" {
  network_interface_id = azurerm_network_interface.myvmnic1.id
  network_security_group_id = azurerm_network_security_group.mynsg1.id
}

#Associate Network Interface with NSG
resource "azurerm_network_interface_security_group_association" "mynisga2" {
  network_interface_id = azurerm_network_interface.myvmnic2.id
  network_security_group_id = azurerm_network_security_group.mynsg2.id
}