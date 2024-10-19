data "azurerm_client_config" "current" {}

resource "random_password" "this" {
  length           = 21
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_mysql_flexible_server" "this" {
  name                         = var.settings.name
  resource_group_name          = var.settings.resource_group_name
  location                     = var.settings.location
  version                      = var.settings.version
  delegated_subnet_id          = var.settings.delegated_subnet_id
  private_dns_zone_id          = var.settings.private_dns_zone_id
  zone                         = var.settings.zone
  sku_name                     = var.settings.sku_name
  backup_retention_days        = var.settings.backup_retention_days
  geo_redundant_backup_enabled = var.settings.geo_redundant_backup_enabled
  administrator_login          = var.settings.administrator_login
  administrator_password       = random_password.this.result
  create_mode                  = var.settings.create_mode
  source_server_id             = var.settings.source_server_id


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
      mode                      = high_availability.value.mode
      standby_availability_zone = high_availability.value.standby_availability_zone
    }
  }

  dynamic "storage" {
    for_each = var.settings.storage != null ? [var.settings.storage] : []

    content {
      auto_grow_enabled = storage.value.auto_grow_enabled
      iops              = storage.value.iops
      size_gb           = storage.value.size_gb
    }
  }

  tags = var.settings.tags
}

/*resource "azurerm_mysql_flexible_server_active_directory_administrator" "this" {
  server_id   = azurerm_mysql_flexible_server.this.id
  identity_id = module.managed-identity.id
  login       = var.settings.administrator_login
  object_id   = data.azurerm_client_config.current.client_id
  tenant_id   = var.settings.tenant_id
}*/

resource "azurerm_mysql_flexible_server_firewall_rule" "this" {
  for_each            = try({ for n in var.settings.firewall_rule : n.name => n }, {})
  name                = each.key
  resource_group_name = var.settings.resource_group_name
  server_name         = azurerm_mysql_flexible_server.this.name
  start_ip_address    = each.value.start_ip_address
  end_ip_address      = each.value.end_ip_address
}

resource "azurerm_mysql_flexible_database" "this" {
  for_each            = try({ for n in var.settings.azurerm_mysql_flexible_server_database : n.name => n }, {})
  name                = each.key
  server_name         = azurerm_mysql_flexible_server.this.name
  resource_group_name = var.settings.resource_group_name
  collation           = each.value.collation
  charset             = each.value.charset
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
