output "resource_id" {
  value = module.avm.resource_id
}

output "connection_string" {
  description = "Application Insights connection string"
  value       = module.avm.connection_string
  sensitive   = true
}

output "name" {
  value = module.avm.name
}
