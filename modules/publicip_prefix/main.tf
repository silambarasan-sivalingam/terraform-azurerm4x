resource "azurerm_public_ip_prefix" "this" {
  name                = var.settings.name
  location            = var.settings.location
  resource_group_name = var.settings.resource_group_name
  prefix_length       = var.settings.prefix_length
  zones               = var.settings.zones
  tags                = var.settings.tags
}
