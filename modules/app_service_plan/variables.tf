variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku_name" {
  type        = string
  description = "Example: S1"
  default     = "S1"
}

variable "tags" {
  type    = map(string)
  default = {}
}
variable "zone_balancing_enabled" {
  description = "Enable zone redundancy/zone balancing (requires supported SKUs)"
  type        = bool
  default     = false
}
