resource "azurerm_disk_encryption_set" "this" {
  name                      = var.settings.name
  resource_group_name       = var.settings.resource_group_name
  location                  = var.settings.location
  key_vault_key_id          = var.settings.key_vault_key_id
  encryption_type           = var.settings.encryption_type
  auto_key_rotation_enabled = var.settings.auto_key_rotation_enabled

  identity {
    type         = var.settings.identity.type
    identity_ids = var.settings.identity.identity_ids
  }

  tags = var.settings.tags
}
