data "azurerm_client_config" "this" {}

resource "random_password" "this" {
  length           = 32
  special          = true
  override_special = "!@#%*()_+[]{}<>?"
  provider         = random
}
resource "azurerm_mssql_managed_instance" "this" {
  name                = var.settings.name
  resource_group_name = var.settings.resource_group_name
  location            = var.settings.location

  license_type                   = var.settings.license_type
  sku_name                       = var.settings.sku_name
  storage_size_in_gb             = var.settings.storage_size_in_gb
  subnet_id                      = var.settings.subnet_id
  vcores                         = var.settings.vcores
  collation                      = var.settings.collation
  maintenance_configuration_name = var.settings.maintenance_configuration_name
  public_data_endpoint_enabled   = var.settings.public_data_endpoint_enabled
  storage_account_type           = var.settings.storage_account_type
  proxy_override                 = var.settings.proxy_override
  zone_redundant_enabled         = var.settings.zone_redundant_enabled
  timezone_id                    = var.settings.timezone_id

  administrator_login          = var.settings.administrator_login
  administrator_login_password = random_password.this.result
  minimum_tls_version          = var.settings.minimum_tls_version

  dynamic "identity" {
    for_each = var.settings.identity != null ? [var.settings.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  tags = var.settings.tags
}

resource "azurerm_role_assignment" "this" {
  count = var.settings.identity.type == "SystemAssigned" ? 1 : 0

  scope                = "/subscriptions/${data.azurerm_client_config.this.subscription_id}"
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_mssql_managed_instance.this.identity[0].principal_id
  depends_on           = [azurerm_mssql_managed_instance.this]
}

resource "azurerm_mssql_managed_instance_transparent_data_encryption" "this" {
  managed_instance_id = azurerm_mssql_managed_instance.this.id
  key_vault_key_id    = var.settings.key_vault_key_id
  depends_on          = [azurerm_role_assignment.this]
}

resource "azurerm_key_vault_secret" "akv" {
  name         = "secret-${var.settings.name}"
  value        = random_password.this.result
  key_vault_id = var.settings.key_vault_id
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
    private_connection_resource_id = azurerm_mssql_managed_instance.this.id
    is_manual_connection           = false
    subresource_names              = ["managedInstance"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.settings.private_endpoint.private_dns_zone_ids != null ? ["enabled"] : []
    content {
      name                 = "pe-${var.settings.name}-dns-zone-group"
      private_dns_zone_ids = var.settings.private_endpoint.private_dns_zone_ids
    }
  }
}
