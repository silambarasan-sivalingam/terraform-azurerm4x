
# Create the Event-hub namespace
resource "azurerm_eventhub_namespace" "this" {
  name                     = var.settings.name
  location                 = var.settings.location
  resource_group_name      = var.settings.resource_group_name
  sku                      = var.settings.sku
  capacity                 = var.settings.capacity
  minimum_tls_version      = var.settings.minimum_tls_version
  auto_inflate_enabled     = var.settings.auto_inflate_enabled
  dedicated_cluster_id     = var.settings.dedicated_cluster_id
  maximum_throughput_units = var.settings.maximum_throughput_units
  zone_redundant           = var.settings.zone_redundant
  local_authentication_enabled = var.settings.local_authentication_enabled


  dynamic "identity" {
    for_each = var.settings.identity != null ? [var.settings.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "network_rulesets" {
    for_each = var.settings.network_rulesets != null ? [var.settings.network_rulesets] : []
    content {
      default_action                 = var.settings.network_rulesets.default_action
      trusted_service_access_enabled = var.settings.network_rulesets.trusted_service_access_enabled
      public_network_access_enabled  = var.settings.public_network_access_enabled

      dynamic "ip_rule" {
        for_each = var.settings.network_rulesets.ip_rules
        iterator = iprule
        content {
          ip_mask = iprule.value

        }
      }

      dynamic "virtual_network_rule" {
        for_each = var.settings.network_rulesets.subnet_ids
        iterator = subnet
        content {
          subnet_id = subnet.value
        }
      }
    }
  }
  public_network_access_enabled = var.settings.public_network_access_enabled
  tags                          = var.settings.tags
}

resource "azurerm_eventhub_namespace_customer_managed_key" "this" {
  for_each                          = try({ for n in var.settings.customer_managed_key : n.key_vault_key_ids[0] => n }, {})
  eventhub_namespace_id             = azurerm_eventhub_namespace.this.id
  key_vault_key_ids                 = each.value.key_vault_key_ids
  user_assigned_identity_id         = each.value.user_assigned_identity_id
  infrastructure_encryption_enabled = each.value.infrastructure_encryption_enabled
}

resource "azurerm_eventhub" "this" {
  for_each = try({ for np in var.settings.eventhub : np.name => np }, {})

  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.this.name
  resource_group_name = var.settings.resource_group_name
  partition_count     = each.value.partition_count
  message_retention   = each.value.message_retention
  status              = each.value.status

  dynamic "capture_description" {
    for_each = each.value.capture_description != null ? [each.value.capture_description] : []
    content {
      enabled             = capture_description.value.enabled
      encoding            = capture_description.value.encoding
      interval_in_seconds = capture_description.value.interval_in_seconds
      size_limit_in_bytes = capture_description.value.size_limit_in_bytes
      skip_empty_archives = capture_description.value.skip_empty_archives

      dynamic "destination" {
        for_each = capture_description.value.destination != null ? [capture_description.value.destination] : []

        content {
          archive_name_format = destination.value.archive_name_format
          blob_container_name = destination.value.blob_container_name
          name                = destination.value.name
          storage_account_id  = destination.value.storage_account_id
        }
      }
    }
  }
}


resource "azurerm_eventhub_consumer_group" "this" {
  for_each = try({
    for np in var.settings.azurerm_eventhub_consumer_group :
    "${np.eventhub_name}_${np.name}" => np
  }, {})

  name                = each.value.name
  namespace_name      = azurerm_eventhub_namespace.this.name
  eventhub_name       = each.value.eventhub_name
  resource_group_name = var.settings.resource_group_name
  user_metadata       = each.value.user_metadata

  depends_on = [azurerm_eventhub.this]
}

resource "azurerm_eventhub_namespace_authorization_rule" "this" {
  for_each            = try({ for np in var.settings.azurerm_eventhub_namespace_authorization_rule : np.name => np }, {})
  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.this.name
  resource_group_name = var.settings.resource_group_name

  listen = each.value.listen
  send   = each.value.send
  manage = each.value.manage

  depends_on = [azurerm_eventhub_namespace.this]
}

resource "azurerm_eventhub_authorization_rule" "this" {
  for_each            = try({ for np in var.settings.azurerm_eventhub_authorization_rule : np.name => np }, {})
  name                = each.key
  namespace_name      = azurerm_eventhub_namespace.this.name
  eventhub_name       = each.value.eventhub_name
  resource_group_name = var.settings.resource_group_name
  listen              = true
  send                = false
  manage              = false
}

resource "azurerm_eventhub_namespace_schema_group" "this" {
  for_each             = try({ for np in var.settings.azurerm_eventhub_namespace_schema_group : np.name => np }, {})
  name                 = var.settings.azurerm_eventhub_namespace_schema_group.name
  namespace_id         = azurerm_eventhub_namespace.this.id
  schema_compatibility = var.settings.azurerm_eventhub_namespace_schema_group.schema_compatibility
  schema_type          = var.settings.azurerm_eventhub_namespace_schema_group.schema_type
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
    private_connection_resource_id = azurerm_eventhub_namespace.this.id
    is_manual_connection           = false
    subresource_names              = ["namespace"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.settings.private_endpoint.private_dns_zone_ids != null ? ["enabled"] : []
    content {
      name                 = "pe-${var.settings.name}-dns-zone-group"
      private_dns_zone_ids = var.settings.private_endpoint.private_dns_zone_ids
    }
  }
}
