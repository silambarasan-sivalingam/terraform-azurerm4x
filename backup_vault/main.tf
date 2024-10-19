data "azurerm_client_config" "this" {}

resource "azurerm_data_protection_backup_vault" "this" {
  name                = var.settings.name
  resource_group_name = var.settings.resource_group_name
  location            = var.settings.location
  datastore_type      = var.settings.datastore_type
  redundancy          = var.settings.redundancy

  dynamic "identity" {
    for_each = var.settings.identity != null ? [var.settings.identity] : []
    content {
      type = identity.value.type
    }
  }
  tags = var.settings.tags

}

resource "azurerm_role_assignment" "this" {
  scope                = "/subscriptions/${data.azurerm_client_config.this.subscription_id}"
  role_definition_name = "Storage Account Backup Contributor"
  principal_id         = azurerm_data_protection_backup_vault.this.identity[0].principal_id
}


resource "azurerm_data_protection_backup_policy_blob_storage" "this" {
  for_each           = try({ for n in var.settings.data_protection_backup_policy_blob_storage : n.name => n }, {})
  name               = each.key
  vault_id           = azurerm_data_protection_backup_vault.this.id
  retention_duration = each.value.retention_duration
  depends_on         = [azurerm_role_assignment.this]

}

resource "azurerm_data_protection_backup_instance_blob_storage" "this" {
  for_each           = try({ for n in var.settings.data_protection_backup_instance_blob_storage : n.name => n }, {})
  name               = each.key
  vault_id           = azurerm_data_protection_backup_vault.this.id
  location           = var.settings.location
  storage_account_id = each.value.storage_account_id
  backup_policy_id   = azurerm_data_protection_backup_policy_blob_storage.this[each.value.backup_policy_name].id
  depends_on         = [azurerm_role_assignment.this]

}
