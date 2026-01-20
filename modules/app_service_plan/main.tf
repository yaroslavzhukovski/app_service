module "asp" {
  source  = "Azure/avm-res-web-serverfarm/azurerm"
  version = "~> 1.0"

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type                = "Linux"
  sku_name               = var.sku_name
  zone_balancing_enabled = var.zone_balancing_enabled
  tags                   = var.tags
}
