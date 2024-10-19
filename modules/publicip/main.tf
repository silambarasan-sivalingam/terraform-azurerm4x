resource "azurerm_public_ip" "this" {
  name                    = var.settings.name
  resource_group_name     = var.settings.resource_group_name
  location                = var.settings.location
  allocation_method       = var.settings.allocation_method
  ddos_protection_mode    = var.settings.ddos_protection_mode
  ddos_protection_plan_id = var.settings.ddos_protection_plan_id
  domain_name_label       = var.settings.domain_name_label
  sku                     = var.settings.sku
  zones                   = var.settings.zones
  ip_tags                 = var.settings.ip_tags
  tags                    = var.settings.tags
}
