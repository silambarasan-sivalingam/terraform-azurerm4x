resource "azurerm_monitor_private_link_scope" "this" {
  name                = var.settings.name
  resource_group_name = var.settings.resource_group_name
  tags                = var.settings.tags
}


resource "azurerm_private_endpoint" "this" {
  name                          = "pe-${var.settings.name}"
  location                      = var.settings.location
  resource_group_name           = var.settings.resource_group_name
  subnet_id                     = var.settings.private_endpoint.subnet_id
  custom_network_interface_name = replace(var.settings.name, "pe-", "penic-")
  private_service_connection {
    name                           = var.settings.private_endpoint.connection_name
    private_connection_resource_id = azurerm_monitor_private_link_scope.this.id
    is_manual_connection           = false
    subresource_names              = ["azuremonitor"]
  }
  private_dns_zone_group {
    name                 = "${var.settings.name}}-dns-zone-group"
    private_dns_zone_ids = var.settings.private_endpoint.private_dns_zone_ids
  }
}

