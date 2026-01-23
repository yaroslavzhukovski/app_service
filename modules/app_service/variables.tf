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

variable "deployment_slots" {
  description = "Deployment slots configuration"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
variable "vnet_integration_subnet_id" {
  description = "Subnet resource ID for App Service VNet Integration (delegated subnet)."
  type        = string
  default     = null
}
variable "enable_vnet_integration" {
  description = "Enable App Service VNet Integration (swift connection)."
  type        = bool
  default     = false

  validation {
    condition     = var.enable_vnet_integration == false || (var.vnet_integration_subnet_id != null && length(var.vnet_integration_subnet_id) > 0)
    error_message = "When enable_vnet_integration is true, vnet_integration_subnet_id must be provided and non-empty."
  }
}
variable "site_config" {
  description = "site_config object passed to AVM web app module"
  type        = any
  default     = {}
}
variable "enable_application_insights" {
  description = "If false, AVM will NOT create Application Insights. We will use an existing one via app settings."
  type        = bool
  default     = false
}
