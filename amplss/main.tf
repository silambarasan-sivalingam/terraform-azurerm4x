terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_monitor_private_link_scoped_service" "this" {
  name                = var.settings.name
  resource_group_name = var.settings.resource_group_name
  scope_name          = var.settings.scope_name
  linked_resource_id  = var.settings.linked_resource_id

}
