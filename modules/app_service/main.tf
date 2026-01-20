module "site" {
  source  = "Azure/avm-res-web-site/azurerm"
  version = "~> 0.19"

  kind                = "webapp"
  os_type             = "Linux"
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  service_plan_resource_id = var.service_plan_id

  https_only = true

  managed_identities = {
    system_assigned = true
  }

  app_settings = var.app_settings

  # Deployment slots (AVM-native)
  deployment_slots = var.deployment_slots

  tags = var.tags
}
# Outbound VNet Integration (optional)
# Outbound VNet Integration (optional)
resource "azurerm_app_service_virtual_network_swift_connection" "this" {
  count = var.enable_vnet_integration ? 1 : 0

  app_service_id = module.site.resource_id
  subnet_id      = var.vnet_integration_subnet_id
}

