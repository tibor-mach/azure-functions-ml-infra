
data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "container_rg" {
  name     = "${var.prefix}-containers-rg-${var.environment}"
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}containers${var.environment}"
  resource_group_name = azurerm_resource_group.container_rg.name
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = false

  identity {
    type = "SystemAssigned"
  }
}