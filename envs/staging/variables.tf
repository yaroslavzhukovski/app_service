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
