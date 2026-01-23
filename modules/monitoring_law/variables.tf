variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }

variable "tags" {
  type    = map(string)
  default = {}
}

variable "sku" {
  type    = string
  default = "PerGB2018"
}

variable "retention_in_days" {
  type    = number
  default = 30
}

# В AVM это string-значения (true/false/SecuredByPerimeter) :contentReference[oaicite:3]{index=3}
variable "internet_ingestion_enabled" {
  type    = string
  default = "false"
}

variable "internet_query_enabled" {
  type    = string
  default = "false"
}

variable "enable_telemetry" {
  type    = bool
  default = false
}
