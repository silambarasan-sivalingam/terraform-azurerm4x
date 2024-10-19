data "azurerm_subscription" "this" {}

# data "azuread_service_principal" "cosmos-app" {
#   client_id = "a232010e-820c-4083-83bb-3ace5fc29d0b"
# }

locals {
  microsoft_azure_cosmos_principal_id = "c5489726-e60e-4d80-af62-9ef34f562686"
}

# resource "azurerm_role_assignment" "this" {
#   scope                = data.azurerm_subscription.this.id
#   role_definition_name = "Key Vault Crypto Service Encryption User"
#   principal_id         = data.azuread_service_principal.cosmos-app.object_id
#   #skip_service_principal_aad_check = true
# }

resource "azurerm_cosmosdb_account" "this" {
  name                = var.settings.name
  location            = var.settings.location
  resource_group_name = var.settings.resource_group_name
  offer_type          = var.settings.offer_type
  kind                = var.settings.kind
  key_vault_key_id    = var.settings.key_vault_key_id

  analytical_storage_enabled = var.settings.analytical_storage_enabled

  dynamic "analytical_storage" {
    for_each = var.settings.analytical_storage_enabled != null ? ["enabled"] : []
    content {
      schema_type = var.settings.analytical_storage.schema_type
    }
  }

  dynamic "capabilities" {
    for_each = var.settings.capabilities != null ? var.settings.capabilities : []
    content {
      name = capabilities.value.name
    }
  }

  dynamic "capacity" {
    for_each = var.settings.capacity != null ? var.settings.capacity : []
    content {
      total_throughput_limit = capacity.value.total_throughput_limit
    }
  }

  dynamic "geo_location" {
    for_each = var.settings.geo_location != null ? var.settings.geo_location : []
    content {
      location          = geo_location.value.location
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = geo_location.value.zone_redundant
    }
  }

  consistency_policy {
    consistency_level       = var.settings.consistency_policy.consistency_level
    max_interval_in_seconds = var.settings.consistency_policy.max_interval_in_seconds
    max_staleness_prefix    = var.settings.consistency_policy.max_staleness_prefix
  }

  ip_range_filter                       = try(join(",", var.settings.ip_range_filter), null)
  public_network_access_enabled         = var.settings.public_network_access_enabled
  is_virtual_network_filter_enabled     = var.settings.is_virtual_network_filter_enabled
  network_acl_bypass_for_azure_services = var.settings.network_acl_bypass_for_azure_services
  network_acl_bypass_ids                = var.settings.network_acl_bypass_ids

  dynamic "virtual_network_rule" {
    for_each = var.settings.virtual_network_rule != null ? toset(var.settings.virtual_network_rule) : []
    content {
      id                                   = virtual_network_rule.value.id
      ignore_missing_vnet_service_endpoint = virtual_network_rule.value.ignore_missing_vnet_service_endpoint
    }
  }

  dynamic "backup" {
    for_each = var.settings.backup != null ? ["enabled"] : []
    content {
      type                = var.settings.backup.type
      interval_in_minutes = var.settings.backup.interval_in_minutes
      retention_in_hours  = var.settings.backup.retention_in_hours
    }
  }

  dynamic "identity" {
    for_each = var.settings.identity != null ? [var.settings.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }


  tags = var.settings.tags
  lifecycle {
    ignore_changes = [capabilities]
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
    private_connection_resource_id = azurerm_cosmosdb_account.this.id
    is_manual_connection           = false
    subresource_names              = var.settings.private_endpoint.subresource_names
  }

  dynamic "private_dns_zone_group" {
    for_each = var.settings.private_endpoint.private_dns_zone_ids != null ? ["enabled"] : []
    content {
      name                 = "pe-${var.settings.name}-dns-zone-group"
      private_dns_zone_ids = var.settings.private_endpoint.private_dns_zone_ids
    }
  }
}
