locals {

}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}
module "networking" {
  source            = "../../modules/networking"
  name              = var.vnet_name
  location          = azurerm_resource_group.rg.location
  resource_group_id = azurerm_resource_group.rg.id
  address_spaces    = var.vnet_address_spaces
  subnets           = var.vnet_subnets
  tags              = var.tags

}
