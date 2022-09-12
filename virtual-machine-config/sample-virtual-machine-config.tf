#Automation Account
resource "azurerm_automation_account" "myaa" {
  name                = "my-automation-account"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  sku_name            = "Basic"
}

#Automation DSC Configuration
resource "azurerm_automation_dsc_configuration" "myadscc" {
  name                    = "dsc_01"
  resource_group_name     = azurerm_resource_group.myrg.name
  automation_account_name = azurerm_automation_account.myaa.name
  location                = azurerm_resource_group.myrg.location
  content_embedded        = "configuration test {}"
}

#Automation DSC NodeConfiguration
resource "azurerm_automation_dsc_nodeconfiguration" "myadscnc" {
  name                    = "localhost"
  resource_group_name     = azurerm_resource_group.myrg.name
  automation_account_name = azurerm_automation_account.myaa.name
  depends_on              = [azurerm_automation_dsc_configuration.myadscc]
 content_embedded = <<mofcontent
 {
  WindowsFeature MyFeatureInstance {
    Ensure = 'Present'
    Name = 'myvm-1'
  }
 }
 mofcontent 
}