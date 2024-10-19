terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_virtual_network_peering" "this" {
  name                         = var.settings.name
  resource_group_name          = var.settings.resource_group_name
  virtual_network_name         = var.settings.virtual_network_name
  remote_virtual_network_id    = var.settings.remote_virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = var.settings.allow_gateway_transit
  use_remote_gateways          = var.settings.use_remote_gateways
}
