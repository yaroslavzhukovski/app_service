variable "location" {
  type        = string
  description = "Azure region"
}
variable "resource_group_id" {
  type        = string
  description = "Resource Group ID"

}
variable "name" {
  type        = string
  description = "Virtual Network Name"

}
variable "address_spaces" {
  type        = list(string)
  description = "Address spaces for the Virtual Network"

}
variable "subnets" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
  description = "Map of subnets"
}
variable "tags" {
  type        = map(string)
  description = "Tags for the Virtual Network"
}
