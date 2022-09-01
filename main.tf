terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3"
    }
  }
}

provider "azurerm" {
  features {}
}

module "container-registry" {
  source      = "./modules/container-registry"
  environment = "test"
}

module "app" {
  source      = "./modules/app"
  app_name    = "skynet"
  environment = "test"
  acr_name    = module.container-registry.name
  acr_id      = module.container-registry.id
  acr_url     = module.container-registry.login_server
  image_name  = "iris"
  image_tag   = "latest"
}
