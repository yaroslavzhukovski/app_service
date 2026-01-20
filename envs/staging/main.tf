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

  sku_name               = var.asp_sku_name
  tags                   = var.tags
  zone_balancing_enabled = false
}

module "app_service" {
  source = "../../modules/app_service"

  name                = var.webapp_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  service_plan_id            = module.app_service_plan.id
  enable_vnet_integration    = true
  vnet_integration_subnet_id = module.networking.subnet_ids["appsvc_int"]

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }


  deployment_slots = {
    staging = {
      name = "staging"

      app_settings = {
        ENVIRONMENT = "staging"
      }
    }
  }

  tags = var.tags
}
module "storage" {
  source = "../../modules/storage"

  name                = var.storage_name
  container_name      = var.storage_container_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  # PE subnet
  private_endpoint_subnet_id = module.networking.subnet_ids["pe"]

  # Private DNS link
  vnet_id = module.networking.vnet_id

  # RBAC principal
  web_app_principal_id = module.app_service.principal_id

  tags = var.tags
}
