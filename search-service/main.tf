
resource "azurerm_search_service" "this" {
  name                                     = var.settings.name
  resource_group_name                      = var.settings.resource_group_name
  location                                 = var.settings.location
  sku                                      = var.settings.sku
  replica_count                            = var.settings.replica_count
  partition_count                          = var.settings.partition_count
  public_network_access_enabled            = var.settings.public_network_access_enabled
  local_authentication_enabled             = var.settings.local_authentication_enabled
  customer_managed_key_enforcement_enabled = var.settings.customer_managed_key_enforcement_enabled
  allowed_ips                              = var.settings.allowed_ips
  semantic_search_sku                      = var.settings.semantic_search_sku
  hosting_mode                             = var.settings.hosting_mode
  authentication_failure_mode              = var.settings.authentication_failure_mode
  tags                                     = var.settings.tags

  dynamic "identity" {
    for_each = var.settings.identity != null ? [var.settings.identity] : []
    content {
      type = identity.value.type
    }
  }

}


resource "azurerm_private_endpoint" "this" {
  count                         = var.settings.private_endpoint != null ? 1 : 0
  name                          = "pe-${var.settings.name}"
  location                      = var.settings.location
  resource_group_name           = var.settings.resource_group_name
  subnet_id                     = var.settings.private_endpoint.subnet_id
  custom_network_interface_name = replace("pe-${var.settings.name}", "pe-", "penic-")
  tags                          = var.settings.tags
  private_service_connection {
    name                           = "pe-${var.settings.name}"
    private_connection_resource_id = azurerm_search_service.this.id
    is_manual_connection           = false
    subresource_names              = ["searchService"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.settings.private_endpoint.private_dns_zone_ids != null ? ["enabled"] : []
    content {
      name                 = "pe-${var.settings.name}-dns-zone-group"
      private_dns_zone_ids = var.settings.private_endpoint.private_dns_zone_ids
    }
  }
}

