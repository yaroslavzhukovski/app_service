module "site" {
  source  = "Azure/avm-res-web-site/azurerm"
  version = "~> 0.19"

  # Linux Web App
  kind                = "webapp"
  os_type             = "Linux"
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  service_plan_resource_id = var.service_plan_id

  # Enforce HTTPS
  https_only = true

  # System-assigned managed identity
  managed_identities = {
    system_assigned = true
  }

  # Application configuration
  app_settings = var.app_settings

  # Deployment slots
  web_app_slots = var.web_app_slots

  tags = var.tags
}
