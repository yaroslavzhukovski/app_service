variable "location" {
  type        = string
  description = "Azure region"
  default     = "swedencentral"
}

variable "env" {
  type        = string
  description = "Environment name"
  default     = "staging"
}

variable "name_prefix" {
  type        = string
  description = "Naming prefix"
  default     = "acme-demo"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default = {
    managedBy = "terraform"
  }
}
variable "vnet_address_spaces" {
  type        = list(string)
  description = "Address spaces for the Virtual Network"


}
variable "vnet_subnets" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
  description = "Map of subnets"

}
variable "vnet_name" {
  type        = string
  description = "Virtual Network Name"

}
variable "rg_name" {
  type        = string
  description = "Resource Group Name"

}
