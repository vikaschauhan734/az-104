#Load Balancer
resource "azurerm_lb" "mylb" {
  name                = "LoadBalancer-1"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.mypublicip1.id
  }
  sku = "Standard"
}

#Load Balancer Backend Address Pool
resource "azurerm_lb_backend_address_pool" "mylbbap" {
  loadbalancer_id = azurerm_lb.mylb.id
  name            = "BackEndAddressPool"
}

#Load Balancer Backend Address Pool Address
resource "azurerm_lb_backend_address_pool_address" "mylbbapa" {
  name                                = "address1"
  backend_address_pool_id             = azurerm_lb_backend_address_pool.mylbbap.id
  virtual_network_id = azurerm_virtual_network.myvnet.id
  ip_address = "10.0.0.1"
}

#Health Probe
resource "azurerm_lb_probe" "mylbp" {
  loadbalancer_id = azurerm_lb.mylb.id
  name            = "tcp-running-probe"
  port            = 80
}

#Load Balancer Rule
resource "azurerm_lb_rule" "mylbr" {
  loadbalancer_id                = azurerm_lb.mylb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
}