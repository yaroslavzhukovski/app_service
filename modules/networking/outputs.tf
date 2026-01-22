output "vnet_id" {
  value = module.vnet.resource_id
}

output "subnet_ids" {
  description = "Subnet resource IDs keyed by subnet map key."
  value = merge(
    { for k, s in module.vnet.subnets : k => s.resource_id },
    { appsvc_int = module.subnet_appsvc_int.resource_id }
  )
}



output "subnet_names" {
  value = { for k, s in module.vnet.subnets : k => s.name }
}
output "private_dns_zone_blob_id" {
  description = "Private DNS zone ID for privatelink.blob.core.windows.net."
  value       = try(azurerm_private_dns_zone.blob[0].id, null)
}
