output "vnet_id" {
  value = module.vnet.id
}
output "vnet_name" {
  value = module.vnet.name
}
output "subnet_ids" {
  value = { for k, s in module.vnet.subnets : k => s.id }
}
output "subnet_names" {
  value = { for k, s in module.vnet.subnets : k => s.name }
}
