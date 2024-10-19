resource "azurerm_resource_group" "this" {
  name     = var.settings.name
  location = var.settings.location
  tags     = var.settings.tags
}
