module "avm" {
  source  = "Azure/avm-res-insights-component/azurerm"
  version = "~> 0.1"

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  # ключевое: workspace-based
  workspace_id = var.log_analytics_workspace_id

  application_type = "web"
  tags             = var.tags

  enable_telemetry = var.enable_telemetry
}
