#Azure Subnet
resource "azurerm_subnet" "mysubnet3" {
  name = "mysubnet-3"
  resource_group_name = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes = [ "10.0.0.0/27" ]
}

#Public IP Address
resource "azurerm_public_ip" "mypublicip3" {
  name = "mypublicip-3"
  resource_group_name = azurerm_resource_group.myrg.name
  location = azurerm_resource_group.myrg.location
  allocation_method = "Dynamic"
}

#Application Gateway
resource "azurerm_application_gateway" "myag" {
  name                = "myappgateway-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  
  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.mysubnet3.id
  }

  frontend_port {
    name = "frontendport-1"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontendipconfig-1"
    public_ip_address_id = azurerm_public_ip.mypublicip3.id
  }

  backend_address_pool {
    name = "backendaddresspool"
  }

  backend_http_settings {
    name                  = "backendhttpsetting-1"
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "httplistener-1"
    frontend_ip_configuration_name = "frontendipconfig-1"
    frontend_port_name             = "frontendport-1"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing-rule-1"
    rule_type                  = "Basic"
    http_listener_name         = "httplistener-1"
    backend_address_pool_name  = "backendaddresspool"
    backend_http_settings_name = "backendhttpsetting-1"
  }
}