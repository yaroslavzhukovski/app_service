resource "azurerm_resource_group" "this" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

module "networking" {
  source = "../../modules/networking"

  location            = var.location
  resource_group_id   = azurerm_resource_group.this.id
  resource_group_name = azurerm_resource_group.this.name

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
  site_config = {
    always_on        = true
    app_command_line = "gunicorn --bind 0.0.0.0:8000 app:app"

    application_stack = {
      main = {
        python_version = "3.11"
      }
    }
  }
  app_settings = {


    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    # Gunicorn port
    WEBSITES_PORT = "8000"

    # Storage target for the app
    AZURE_STORAGE_ACCOUNT_NAME   = module.storage.storage_account_name
    AZURE_STORAGE_CONTAINER_NAME = module.storage.container_name

    APPLICATIONINSIGHTS_CONNECTION_STRING = module.app_insights.connection_string
  }



  deployment_slots = {
    staging = {
      name = "staging"

      app_settings = {
        ENVIRONMENT                    = "staging"
        SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
        WEBSITES_PORT                  = "8000"

      }
      site_config = {
        always_on        = true
        app_command_line = "gunicorn --bind 0.0.0.0:8000 app:app"
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

  private_dns_zone_id           = module.networking.private_dns_zone_blob_id
  public_network_access_enabled = false

  tags = var.tags
}
module "log_analytics_workspace" {
  source = "../../modules/monitoring_law"

  name                = "law-appsvc-stg-swc-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags

  retention_in_days = 30
}
module "app_insights" {
  source = "../../modules/monitoring_appinsight"

  name                = "appi-appsvc-stg-swc-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags

  log_analytics_workspace_id = module.log_analytics_workspace.resource_id
}
module "webapp_diagnostics" {
  source = "../../modules/monitor_diagnostic_settings"

  name                       = "diag-webapp"
  target_resource_id         = module.app_service.resource_id
  log_analytics_workspace_id = module.log_analytics_workspace.resource_id

  log_categories = toset([
    "AppServiceHTTPLogs",
    "AppServiceConsoleLogs",
    "AppServiceAuditLogs",
    "AppServiceIPSecAuditLogs"
  ])

  metric_categories = toset(["AllMetrics"])
}
module "storage_blob_diagnostics" {
  source = "../../modules/monitor_diagnostic_settings"

  name                       = "diag-storage-blob"
  target_resource_id         = module.storage.blob_service_id
  log_analytics_workspace_id = module.log_analytics_workspace.resource_id

  log_categories = toset([
    "StorageRead",
    "StorageWrite",
    "StorageDelete"
  ])

  metric_categories = toset(["AllMetrics"])
}
