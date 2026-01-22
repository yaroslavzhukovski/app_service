variable "location" {
  type        = string
  description = "Azure region, e.g. swedencentral"
}

variable "resource_group_id" {
  type        = string
  description = "Resource Group ID where the VNet will be deployed (parent_id for AVM module)."
}

variable "vnet_name" {
  type        = string
  description = "Name of the VNet."
}

variable "address_space" {
  type        = set(string)
  description = "VNet address space(s). Example: [\"10.40.0.0/16\"]."
}

variable "subnets" {
  description = "Map of subnets to create."
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
}
variable "resource_group_name" {
  type        = string
  description = "Resource Group name where the VNet will be deployed."

}
variable "tags" {
  type        = map(string)
  description = "Common tags."
  default     = {}
}
variable "enable_private_dns_blob" {
  description = "Create and link privatelink.blob.core.windows.net Private DNS zone."
  type        = bool
  default     = true
}

