resource "azurerm_resource_group" "this" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

module "networking" {
  source = "../../modules/networking"

  location          = var.location
  resource_group_id = azurerm_resource_group.this.id

  vnet_name     = var.vnet_name
  address_space = var.vnet_address_space
  subnets       = var.subnets
  tags          = var.tags
}
module "app_service_plan" {
  source = "../../modules/app_service_plan"

  name                = var.asp_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  sku_name = var.asp_sku_name
  tags     = var.tags
}

module "app_service" {
  source = "../../modules/app_service"

  name                = var.webapp_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  service_plan_id = module.app_service_plan.id

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }

  web_app_slots = {
    staging = {
      name = "staging"
      app_settings = {
        ENVIRONMENT = "staging"
      }
    }
  }

  tags = var.tags
}
