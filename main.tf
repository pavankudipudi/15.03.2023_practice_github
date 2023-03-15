# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Create a resource group for the VM
resource "azurerm_resource_group" "pavan_rg" {
  name     = "nagendra-rg"
  location = "East US"
}