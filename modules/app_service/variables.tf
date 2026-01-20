variable "name" {
  description = "Web App name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "service_plan_id" {
  description = "App Service Plan resource ID"
  type        = string
}

variable "app_settings" {
  description = "Application settings"
  type        = map(string)
  default     = {}
}

variable "web_app_slots" {
  description = "Deployment slots configuration"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
