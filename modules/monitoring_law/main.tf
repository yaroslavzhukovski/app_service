module "avm" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "~> 0.5"

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags


  log_analytics_workspace_sku               = var.sku
  log_analytics_workspace_retention_in_days = var.retention_in_days


  log_analytics_workspace_internet_ingestion_enabled = var.internet_ingestion_enabled
  log_analytics_workspace_internet_query_enabled     = var.internet_query_enabled


  enable_telemetry = var.enable_telemetry
}
