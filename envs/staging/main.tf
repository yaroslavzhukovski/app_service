locals {
  workload = "${var.name_prefix}-${var.env}"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.workload}-${var.location}"
  location = var.location
  tags     = var.tags
}
