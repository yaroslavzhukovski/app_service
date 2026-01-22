variable "name" {
  description = "Storage account name (globally unique, lowercase)."
  type        = string
}

variable "container_name" {
  description = "Blob container name."
  type        = string
  default     = "appdata"
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "replication_type" {
  description = "Replication type (e.g. LRS, ZRS)."
  type        = string
  default     = "LRS"
}

variable "public_network_access_enabled" {
  description = "Controls public network access for the storage account."
  type        = bool
  default     = true
}
variable "private_dns_zone_id" {
  description = "Private DNS zone ID for privatelink.blob.core.windows.net."
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoints."
  type        = string
}

variable "vnet_id" {
  description = "VNet ID for Private DNS zone link."
  type        = string
}

variable "web_app_principal_id" {
  description = "Web App system-assigned managed identity principal ID."
  type        = string
}

variable "tags" {
  description = "Resource tags."
  type        = map(string)
  default     = {}
}
