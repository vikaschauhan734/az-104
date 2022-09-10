#Availability Set
resource "azurerm_availability_set" "myaset" {
  name                = "myaset-1"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  platform_fault_domain_count = 2
  platform_update_domain_count = 5
}

