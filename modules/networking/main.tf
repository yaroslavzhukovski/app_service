module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm/"
  version = "0.17.1"
  name=var.name
  location=var.location
  parent_id=var.resource_group_id
    address_spaces=var.address_spaces
    subnets{
        for k, s in var.subnets : k => {
            name=s.name
            address_prefixes=s.address_prefixes
    }
    }
    tags=var.tags
}