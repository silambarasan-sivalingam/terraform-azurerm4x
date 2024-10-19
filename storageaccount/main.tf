terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}
resource "azurerm_storage_account" "this" {
  name                              = var.settings.name
  resource_group_name               = var.settings.resource_group_name
  location                          = var.settings.location
  account_kind                      = var.settings.account_kind
  account_tier                      = var.settings.account_tier
  account_replication_type          = var.settings.account_replication_type
  allow_nested_items_to_be_public   = false
  edge_zone                         = var.settings.edge_zone
  enable_https_traffic_only         = true
  access_tier                       = var.settings.access_tier
  min_tls_version                   = "TLS1_2"
  shared_access_key_enabled         = var.settings.shared_access_key_enabled
  tags                              = var.settings.tags
  large_file_share_enabled          = var.settings.large_file_share_enabled
  nfsv3_enabled                     = var.settings.nfsv3_enabled
  public_network_access_enabled     = var.settings.public_network_access_enabled
  infrastructure_encryption_enabled = var.settings.infrastructure_encryption_enabled
  queue_encryption_key_type         = var.settings.queue_encryption_key_type
  table_encryption_key_type         = var.settings.table_encryption_key_type
  dynamic "blob_properties" {
    for_each = var.settings.blob_properties != null ? [var.settings.blob_properties] : []

    content {
      delete_retention_policy {
        days = var.settings.blob_properties.delete_retention_policy.days
      }

    dynamic "container_delete_retention_policy" {
        for_each = var.settings.blob_properties.container_delete_retention_policy != null ? [var.settings.blob_properties.container_delete_retention_policy] : []
        content {
            days = container_delete_retention_policy.value.days
        }
    }
      container_delete_retention_policy {
        
      }
      versioning_enabled       = var.settings.blob_properties.versioning_enabled
      last_access_time_enabled = var.settings.blob_properties.last_access_time_enabled
      change_feed_enabled      = var.settings.blob_properties.change_feed_enabled
    }
  }

  dynamic "static_website" {
    for_each = var.settings.static_website != null ? [var.settings.static_website] : []

    content {
      index_document     = static_website.value.index_document
      error_404_document = try(static_website.value.error_404_document, null)
    }
  }

  dynamic "identity" {
    for_each = var.settings.identity != null ? [var.settings.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "customer_managed_key" {
    for_each = var.settings.customer_managed_key != null ? [var.settings.customer_managed_key] : []
    content {
      key_vault_key_id          = customer_managed_key.value.key_vault_key_id
      user_assigned_identity_id = customer_managed_key.value.user_assigned_identity_id
    }
  }

  dynamic "routing" {
    for_each = var.settings.routing != null ? [var.settings.routing] : []
    content {
      publish_internet_endpoints  = routing.value.publish_internet_endpoints
      publish_microsoft_endpoints = routing.value.publish_microsoft_endpoints
      choice                      = routing.value.choice
    }
  }


  dynamic "network_rules" {
    for_each = var.settings.network_rules != null ? var.settings.network_rules : []
    content {
      default_action             = network_rules.default_action
      ip_rules                   = network_rules.ip_rules
      virtual_network_subnet_ids = network_rules.virtual_network_subnet_ids
      bypass                     = ["Logging", "Metrics", "AzureServices"]
    }

  }

  lifecycle {
    ignore_changes = [
      # static_website, 
      blob_properties[0]
    ]
  }
}


resource "azurerm_storage_container" "this" {
  for_each              = try({ for c in var.settings.containers : c.name => c }, {})
  name                  = each.key
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
  #depends_on            = [azurerm_private_endpoint.pvtep_storage]
}

resource "azurerm_storage_share" "this" {
  for_each             = try({ for s in var.settings.file_shares : s.name => s }, {})
  name                 = each.key
  storage_account_name = azurerm_storage_account.this.name
  quota                = each.value.quota_in_gb
  enabled_protocol     = each.value.enabled_protocol
  metadata             = each.value.metadata

  dynamic "acl" {
    for_each = each.value.acl != null ? each.value.acl : []

    content {
      id = acl.value.id

      access_policy {
        permissions = acl.value.permissions
        start       = acl.value.start
        expiry      = acl.value.expiry
      }
    }
  }
}

resource "azurerm_storage_queue" "this" {
  for_each             = try({ for q in var.settings.queues : q.name => q }, {})
  name                 = each.key
  storage_account_name = azurerm_storage_account.this.name
}

resource "azurerm_storage_table" "this" {
  for_each             = try({ for t in var.settings.tables : t.name => t }, {})
  name                 = each.key
  storage_account_name = azurerm_storage_account.this.name
}

resource "azurerm_private_endpoint" "this" {
  count                         = var.settings.private_endpoint != null ? 1 : 0
  name                          = "pe-${var.settings.name}"
  location                      = var.settings.location
  resource_group_name           = var.settings.private_endpoint.resource_group_name != null ? var.settings.private_endpoint.resource_group_name : var.settings.resource_group_name
  subnet_id                     = var.settings.private_endpoint.subnet_id
  custom_network_interface_name = replace("pe-${var.settings.name}", "pe-", "penic-")
  private_service_connection {
    name                           = "pe-${var.settings.name}"
    private_connection_resource_id = azurerm_storage_account.this.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = "${var.settings.name}-dns-zone-group"
    private_dns_zone_ids = var.settings.private_endpoint.private_dns_zone_ids
  }
  tags = var.settings.tags
}


resource "azurerm_private_endpoint" "secondary" {
  for_each                      = try({ for n in var.settings.private_endpoint_secondary : n.endpoint_name => n }, {})
  name                          = each.key
  location                      = var.settings.location
  resource_group_name           = each.value.resource_group_name != null ? each.value.resource_group_name : var.settings.resource_group_name
  subnet_id                     = each.value.subnet_id
  custom_network_interface_name = replace(each.key, "pep-", "pepnic-")
  private_service_connection {
    name                           = each.value.connection_name
    private_connection_resource_id = azurerm_storage_account.this.id
    is_manual_connection           = false
    subresource_names              = each.value.subresource_names
  }

  private_dns_zone_group {
    name                 = "${each.key}-dns-zone-group"
    private_dns_zone_ids = each.value.private_dns_zone_ids
  }
}

