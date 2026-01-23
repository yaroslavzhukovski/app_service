variable "name" { type = string }

variable "target_resource_id" {
  type        = string
  description = "Resource ID ресурса, на который вешаем diagnostic settings"
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "LAW resource id"
}

variable "log_categories" {
  type    = set(string)
  default = []
}

variable "metric_categories" {
  type    = set(string)
  default = ["AllMetrics"]
}
