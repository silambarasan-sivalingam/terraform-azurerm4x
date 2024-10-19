data "azurerm_client_config" "current" {}

resource "random_password" "this" {
  length           = 21
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                         = var.settings.name
  resource_group_name          = var.settings.resource_group_name
  location                     = var.settings.location
  version                      = var.settings.version
  delegated_subnet_id          = var.settings.delegated_subnet_id
  private_dns_zone_id          = var.settings.private_dns_zone_id
  zone                         = var.settings.zone
  storage_mb                   = var.settings.storage_mb
  sku_name                     = var.settings.sku_name
  administrator_login          = var.settings.administrator_login
  administrator_password       = random_password.this.result
  backup_retention_days        = var.settings.backup_retention_days
  geo_redundant_backup_enabled = var.settings.geo_redundant_backup_enabled
  create_mode                  = var.settings.create_mode
  source_server_id             = var.settings.source_server_id


  authentication {
    active_directory_auth_enabled = var.settings.authentication.active_directory_auth_enabled
    tenant_id                     = var.settings.authentication.tenant_id
    password_auth_enabled         = var.settings.authentication.password_auth_enabled
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
      key_vault_key_id                  = var.settings.customer_managed_key.key_vault_key_id
      primary_user_assigned_identity_id = var.settings.customer_managed_key.primary_user_assigned_identity_id
    }
  }

  dynamic "high_availability" {
    for_each = var.settings.high_availability != null ? [var.settings.high_availability] : []
    content {
      mode                      = var.settings.high_availability.mode
      standby_availability_zone = var.settings.high_availability.standby_availability_zone
    }
  }

  tags = var.settings.tags
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "this" {
  for_each         = try({ for n in var.settings.firewall_rule : n.name => n }, {})
  name             = each.key
  server_id        = azurerm_postgresql_flexible_server.this.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address

}

resource "azurerm_postgresql_flexible_server_database" "this" {
  for_each  = try({ for n in var.settings.postgresql_flexible_server_database : n.name => n }, {})
  name      = each.key
  server_id = azurerm_postgresql_flexible_server.this.id
  collation = each.value.collation
  charset   = each.value.charset

}

resource "azurerm_key_vault_secret" "this" {
  for_each        = try({ for n in var.settings.key_vault_secret : n.name => n }, {})
  name            = each.key
  value           = random_password.this.result
  key_vault_id    = each.value.key_vault_id
  tags            = var.settings.tags
  expiration_date = "2026-12-31T00:00:00Z"
}
