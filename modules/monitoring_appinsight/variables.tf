variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }

variable "log_analytics_workspace_id" {
  type        = string
  description = "LAW resource id (workspace_id input в AVM App Insights)"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "enable_telemetry" {
  type    = bool
  default = false
}
