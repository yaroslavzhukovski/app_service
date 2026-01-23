output "resource_id" {
  description = "Log Analytics Workspace resource id"
  value       = module.avm.resource_id
}

output "name" {
  description = "Log Analytics Workspace name"
  value       = module.avm.resource.name
}
