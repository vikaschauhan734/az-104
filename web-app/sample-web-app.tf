#Terraform Block
terraform {
  required_version = "> 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0"
     }
  }
}

#Provider Block
provider "azurerm" {
  features {}
}

#Resource Block
#Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  name = "myrg-1"
  location = "Central India"
}

#App Service Plan
resource "azurerm_service_plan" "mysp" {
  name                = "mysp-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

#Web App
resource "azurerm_windows_web_app" "mywa" {
  name                = "vikaschauhanwebappdemo"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  service_plan_id     = azurerm_service_plan.mysp.id
  
  site_config {always_on = false}
}