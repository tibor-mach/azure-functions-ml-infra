resource "azurerm_resource_group" "app_rg" {
  name     = "${var.prefix}-${var.app_name}-rg-${var.environment}"
  location = var.location
}

resource "azurerm_application_insights" "app_insights" {
  name                = "${var.prefix}-${var.app_name}-insights-${var.environment}"
  resource_group_name = azurerm_resource_group.app_rg.name
  location            = var.location
  application_type    = "other"
}

resource "azurerm_service_plan" "service_plan" {
  name                = "${var.prefix}-${var.app_name}-plan-${var.environment}"
  resource_group_name = azurerm_resource_group.app_rg.name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_storage_account" "storage" {
  name                     = "${var.prefix}${var.app_name}storage"
  resource_group_name      = azurerm_resource_group.app_rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_linux_function_app" "azfuncapp" {
  name                          = "${var.prefix}-${var.app_name}-service-${var.environment}"
  resource_group_name           = azurerm_resource_group.app_rg.name
  location                      = var.location
  service_plan_id               = azurerm_service_plan.service_plan.id
  storage_account_name          = azurerm_storage_account.storage.name
  storage_uses_managed_identity = true
  https_only                    = true

  site_config {
    always_on                               = true
    container_registry_use_managed_identity = true
    elastic_instance_minimum                = 0
    app_scale_limit                         = 5

    application_stack {
      docker {
        registry_url = var.acr_url
        image_name   = var.image_name
        image_tag    = var.image_tag
      }
    }
  }

  app_settings = {
    FUNCTION_APP_EDIT_MODE         = "readOnly"
    FUNCTIONS_EXTENSION_VERSION    = "~3"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.app_insights.instrumentation_key
    # explicit 8080 should not be needed according to azure docs but it only listens on 80 otherwise
    WEBSITES_PORT = 8080
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_storage_account.storage, azurerm_service_plan.service_plan]
}

resource "azurerm_role_assignment" "app_role" {
  principal_id         = azurerm_linux_function_app.azfuncapp.identity.0.principal_id
  role_definition_name = "AcrPull"
  scope                = var.acr_id
}