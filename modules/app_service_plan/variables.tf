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
