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

      # Subnet delegation (optional)
      delegation = try(s.delegation, null)

      # Private Endpoint subnet requirement (optional)
      private_endpoint_network_policies_enabled = try(s.private_endpoint_network_policies_enabled, null)
    }
  }

  tags = var.tags
}

