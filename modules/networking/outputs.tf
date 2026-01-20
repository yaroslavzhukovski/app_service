output "vnet_id" {
  value = module.vnet.resource_id
}

output "subnet_ids" {
  description = "Subnet resource IDs keyed by subnet map key."
  value       = { for k, s in module.vnet.subnets : k => s.resource_id }
}


output "subnet_names" {
  value = { for k, s in module.vnet.subnets : k => s.name }
}
