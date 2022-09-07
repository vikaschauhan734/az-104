#Azure DNS Zone
resource "azurerm_dns_zone" "mydns" {
  name = "mysampledomain.com"
  resource_group_name = azurerm_resource_group.myrg.name
}

#Add Record Set
resource "azurerm_dns_a_record" "mydnsrs" {
  name = "www"
  zone_name = azurerm_dns_zone.mydns.name
  resource_group_name = azurerm_resource_group.myrg.name
  ttl = 1
  target_resource_id  = azurerm_public_ip.mypublicip[1].id
}

#Private DNS Zone
resource "azurerm_private_dns_zone" "mypdns" {
  name                = "mydomain.com"
  resource_group_name = azurerm_resource_group.myrg.name
}

#Private DNS Zone Virtual Network Link
resource "azurerm_private_dns_zone_virtual_network_link" "mypdzvnl" {
  name                  = "dns-link-01"
  resource_group_name   = azurerm_resource_group.myrg.name
  private_dns_zone_name = azurerm_private_dns_zone.mypdns.name
  virtual_network_id    = azurerm_virtual_network.myvnet.id
  registration_enabled = true
}

