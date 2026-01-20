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
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
}

variable "tags" {
  type    = map(string)
  default = {}
}
