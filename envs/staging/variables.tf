variable "location" {
  type        = string
  description = "Azure region."
}

variable "rg_name" {
  type        = string
  description = "Resource group name."
}

variable "vnet_name" {
  type        = string
  description = "VNet name."
}

variable "vnet_address_space" {
  type        = set(string)
  description = "VNet CIDR(s)."
}

variable "subnets" {
  description = "Map of subnets to create."
  type = map(object({
    name             = string
    address_prefixes = list(string)

    # Optional: subnet delegation 
    delegations = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string))
      })
    })))

    # Optional: required for Private Endpoints subnet
    private_endpoint_network_policies_enabled = optional(bool)
  }))
}


variable "tags" {
  type    = map(string)
  default = {}
}
variable "asp_name" {
  description = "App Service Plan name"
  type        = string
}

variable "asp_sku_name" {
  description = "App Service Plan SKU"
  type        = string
  default     = "S1"
}

variable "webapp_name" {
  description = "Web App name"
  type        = string
}
variable "storage_name" {
  description = "Storage account name."
  type        = string
}

variable "storage_container_name" {
  description = "Blob container name."
  type        = string
  default     = "appdata"
}
