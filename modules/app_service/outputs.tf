output "resource_id" {
  description = "Web App resource ID"
  value       = module.site.resource_id
}

output "default_hostname" {
  description = "Default hostname of the Web App"
  value       = module.site.resource_uri
}

output "principal_id" {
  description = "System-assigned managed identity principal ID"
  value       = module.site.system_assigned_mi_principal_id
}
