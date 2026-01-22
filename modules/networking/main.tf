module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.17.1"

  name      = var.vnet_name
  location  = var.location
  parent_id = var.resource_group_id

  address_space = var.address_space

  subnets = {
    for k, s in var.subnets : k => {
      name             = s.name
      address_prefixes = s.address_prefixes


      # Private Endpoint subnet requirement (optional)
      private_endpoint_network_policies_enabled = try(s.private_endpoint_network_policies_enabled, null)
    }
  }

  tags = var.tags
}
module "subnet_appsvc_int" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "0.17.1"

  name      = "snet-appsvc-int"
  parent_id = module.vnet.resource_id

  address_prefixes = ["10.40.2.0/24"]

  delegations = [{
    name = "delegation-webapps"
    service_delegation = {
      name = "Microsoft.Web/serverFarms"
    }
  }]


}

# Shared Private DNS (Blob)
resource "azurerm_private_dns_zone" "blob" {
  count               = var.enable_private_dns_blob ? 1 : 0
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  count                 = var.enable_private_dns_blob ? 1 : 0
  name                  = "vnet-link-blob"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.blob[0].name
  virtual_network_id    = module.vnet.resource_id
  registration_enabled  = false
  tags                  = var.tags
}
