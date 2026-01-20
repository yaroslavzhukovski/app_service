module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.17.0" # pin version for stability (important in real projects)

  name      = var.vnet_name
  location  = var.location
  parent_id = var.resource_group_id

  # Basic static addressing (no IPAM for this project)
  address_space = var.address_space

  # Subnets map (AVM pattern)
  subnets = {
    for k, s in var.subnets : k => {
      name             = s.name
      address_prefixes = s.address_prefixes
    }
  }

  tags = var.tags
}
