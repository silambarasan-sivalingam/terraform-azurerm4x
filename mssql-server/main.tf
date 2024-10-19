resource "random_password" "this" {
  length           = 21
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


resource "azurerm_mssql_server" "this" {
  name                                         = var.settings.name
  resource_group_name                          = var.settings.resource_group_name
  location                                     = var.settings.location
  version                                      = var.settings.version
  connection_policy                            = var.settings.connection_policy
  minimum_tls_version                          = var.settings.minimum_tls_version
  public_network_access_enabled                = var.settings.public_network_access_enabled
  outbound_network_restriction_enabled         = var.settings.outbound_network_restriction_enabled
  administrator_login                          = var.settings.administrator_login
  administrator_login_password                 = random_password.this.result
  primary_user_assigned_identity_id            = var.settings.primary_user_assigned_identity_id
  transparent_data_encryption_key_vault_key_id = var.settings.transparent_data_encryption_key_vault_key_id


  dynamic "azuread_administrator" {

    for_each = var.settings.azuread_administrator != null ? [var.settings.azuread_administrator] : []

    content {
      login_username              = azuread_administrator.value.login_username
      object_id                   = azuread_administrator.value.object_id
      tenant_id                   = azuread_administrator.value.tenant_id
      azuread_authentication_only = azuread_administrator.value.azuread_authentication_only
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

}

resource "azurerm_mssql_elasticpool" "this" {
  for_each            = try({ for n in var.settings.elasticpool : n.name => n }, {})
  name                = each.key
  resource_group_name = var.settings.resource_group_name
  location            = var.settings.location
  server_name         = azurerm_mssql_server.this.name
  license_type        = each.value.license_type
  max_size_gb         = each.value.max_size_gb


  dynamic "sku" {
    for_each = each.value.sku != null ? [each.value.sku] : []

    content {
      name     = sku.value.name
      tier     = sku.value.tier
      family   = sku.value.family
      capacity = sku.value.capacity
    }

  }

  dynamic "per_database_settings" {
    for_each = each.value.per_database_settings != null ? [each.value.per_database_settings] : []

    content {
      min_capacity = per_database_settings.value.min_capacity
      max_capacity = per_database_settings.value.max_capacity
    }
  }
}

resource "azurerm_key_vault_secret" "this" {
  for_each        = try({ for n in var.settings.key_vault_secret : n.name => n }, {})
  name            = each.key
  value           = random_password.this.result
  key_vault_id    = each.value.key_vault_id
  expiration_date = local.expiration_date
  tags            = var.settings.tags

  lifecycle {
    ignore_changes = [expiration_date]

  }
}


resource "azurerm_mssql_virtual_network_rule" "this" {
  for_each  = try({ for subnet in var.settings.virtual_network_rule.subnet_id : subnet.name => subnet }, {})
  name      = each.key
  server_id = azurerm_mssql_server.this.id
  subnet_id = each.value.subnet_id
}

resource "azurerm_mssql_database" "this" {
  for_each       = try({ for n in var.settings.mssql_database : n.name => n }, {})
  name           = each.key
  server_id      = azurerm_mssql_server.this.id
  collation      = each.value.collation
  license_type   = each.value.license_type
  max_size_gb    = each.value.max_size_gb
  read_scale     = each.value.read_scale
  sku_name       = each.value.sku_name
  zone_redundant = false
  tags           = var.settings.tags

  dynamic "identity" {
    for_each = each.value.identity != null ? [each.value.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "threat_detection_policy" {
    for_each = each.value.threat_detection_policy ? [each.value.threat_detection_policy] : []
    content {
      state                      = threat_detection_policy.value.state
      storage_endpoint           = threat_detection_policy.value.storage_endpoint
      storage_account_access_key = threat_detection_policy.value.storage_account_access_key
      retention_days             = threat_detection_policy.value.retention_days
      email_addresses            = threat_detection_policy.value.email_addresses
    }
  }

  dynamic "long_term_retention_policy" {
    for_each = each.value.long_term_retention_policy != null ? [each.value.long_term_retention_policy] : []
    content {
      weekly_retention          = long_term_retention_policy.value.weekly_retention
      monthly_retention         = long_term_retention_policy.value.monthly_retention
      yearly_retention          = long_term_retention_policy.value.yearly_retention
      week_of_year              = long_term_retention_policy.value.week_of_year
      immutable_backups_enabled = long_term_retention_policy.value.immutable_backups_enabled
    }
  }

  dynamic "short_term_retention_policy" {
    for_each = each.value.short_term_retention_policy != null ? [each.value.short_term_retention_policy] : []
    content {
      retention_days           = short_term_retention_policy.value.retention_days
      backup_interval_in_hours = short_term_retention_policy.value.backup_interval_in_hours
    }
  }

  transparent_data_encryption_key_vault_key_id = each.value.transparent_data_encryption_key_vault_key_id


}

resource "azurerm_mssql_firewall_rule" "this" {
  for_each         = try({ for n in var.settings.mssql_firewall_rule : n.name => n }, {})
  name             = each.key
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
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
    private_connection_resource_id = azurerm_mssql_server.this.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.settings.private_endpoint.private_dns_zone_ids != null ? ["enabled"] : []
    content {
      name                 = "pe-${var.settings.name}-dns-zone-group"
      private_dns_zone_ids = var.settings.private_endpoint.private_dns_zone_ids
    }
  }
}
