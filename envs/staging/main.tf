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
