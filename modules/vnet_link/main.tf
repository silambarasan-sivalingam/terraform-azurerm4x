terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = var.settings.name
  resource_group_name   = var.settings.resource_group_name
  private_dns_zone_name = var.settings.private_dns_zone_name
  virtual_network_id    = var.settings.virtual_network_id
  registration_enabled  = var.settings.registration_enabled
  tags                  = var.settings.tags
}
