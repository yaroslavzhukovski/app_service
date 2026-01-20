output "storage_account_name" {
  description = "Storage account name."
  value       = azurerm_storage_account.this.name
}

output "container_name" {
  description = "Container name."
  value       = azurerm_storage_container.this.name
}

output "blob_endpoint" {
  description = "Blob endpoint (public hostname; resolves to private IP via Private DNS in the VNet)."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "private_endpoint_id" {
  description = "Private endpoint resource ID."
  value       = azurerm_private_endpoint.blob.id
}
