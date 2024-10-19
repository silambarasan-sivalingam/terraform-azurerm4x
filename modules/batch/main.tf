data "azurerm_client_config" "core" {}
data "azurerm_subscription" "this" {}
locals {
  microsoft_azure_batch_principal_id = "06d82036-5a43-4d4a-8203-a07095cb42bb"
}
# resource "azurerm_role_assignment" "this" {
#   scope                = data.azurerm_subscription.this.id
#   role_definition_name = "Contributor"
#   principal_id         = local.microsoft_azure_batch_principal_id
#   #skip_service_principal_aad_check = true
# }

# resource "azurerm_key_vault_access_policy" "this" {
#   key_vault_id = var.settings.key_vault_reference.id
#   object_id    = local.microsoft_azure_batch_principal_id
#   tenant_id    = data.azurerm_client_config.core.tenant_id
#   secret_permissions = [
#     "Get",
#     "List",
#     "Set",
#     "Delete",
#     "Recover"
#   ]
#   key_permissions = [
#     "Get",
#     "List",
#     "WrapKey",
#     "UnwrapKey"
#   ]
# }

resource "azurerm_batch_account" "this" {
  name                                = var.settings.name
  resource_group_name                 = var.settings.resource_group_name
  location                            = var.settings.location
  pool_allocation_mode                = var.settings.pool_allocation_mode
  storage_account_id                  = var.settings.storage_account_id
  storage_account_authentication_mode = var.settings.storage_account_authentication_mode
  tags                                = var.settings.tags
  storage_account_node_identity       = var.settings.storage_account_node_identity
  allowed_authentication_modes        = var.settings.allowed_authentication_modes
  public_network_access_enabled       = var.settings.public_network_access_enabled

  dynamic "identity" {
    for_each = var.settings.identity != null ? [var.settings.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "network_profile" {

    for_each = var.settings.network_profile != null ? [var.settings.network_profile] : []

    content {
      dynamic "account_access" {
        for_each = network_profile.value.account_access != null ? network_profile.value.account_access : []
        content {
          default_action = account_access.value.default_action
          dynamic "ip_rule" {
            for_each = account_access.value.ip_rule != null ? account_access.value.ip_rule : []
            content {
              ip_range = ip_rule.value.ip_range
              action   = ip_rule.value.action
            }
          }
        }
      }
      dynamic "node_management_access" {
        for_each = network_profile.value.node_management_access != null ? network_profile.value.node_management_access : []
        content {
          default_action = node_management_access.value.default_action
          dynamic "ip_rule" {
            for_each = node_management_access.value.ip_rule != null ? node_management_access.value.ip_rule : []

            content {
              ip_range = ip_rule.value.ip_range
              action   = ip_rule.value.action
            }
          }

        }
      }
    }
  }

  dynamic "encryption" {
    for_each = var.settings.encryption != null ? [var.settings.encryption] : []
    content {
      key_vault_key_id = encryption.value.key_vault_key_id
    }
  }

  dynamic "key_vault_reference" {
    for_each = var.settings.key_vault_reference != null ? [var.settings.key_vault_reference] : []
    content {
      id  = key_vault_reference.value.id
      url = key_vault_reference.value.url
    }
  }
}


resource "azurerm_batch_application" "this" {
  for_each            = try({ for c in var.settings.batch_application : c.name => c }, {})
  name                = each.key
  resource_group_name = var.settings.resource_group_name
  account_name        = azurerm_batch_account.this.name
  allow_updates       = each.value.allow_updates
  default_version     = each.value.default_version
  display_name        = each.value.display_name
}


resource "azurerm_private_endpoint" "batchAccount" {
  count                         = var.settings.private_endpoint != null ? 1 : 0
  name                          = "pe-${var.settings.name}-batchAccount"
  location                      = var.settings.location
  resource_group_name           = var.settings.resource_group_name
  subnet_id                     = var.settings.private_endpoint.subnet_id
  custom_network_interface_name = "pe-nic-${var.settings.name}-batchAccount"
  tags                          = var.settings.tags
  private_service_connection {
    name                           = "pe-${var.settings.name}-batchAccount"
    private_connection_resource_id = azurerm_batch_account.this.id
    is_manual_connection           = false
    subresource_names              = ["batchAccount"]
  }
  dynamic "private_dns_zone_group" {
    for_each = var.settings.private_endpoint.private_dns_zone_ids != null ? ["enabled"] : []
    content {
      name                 = "pe-${var.settings.name}-batchAccount-dns-zone-group"
      private_dns_zone_ids = var.settings.private_endpoint.private_dns_zone_ids
    }
  }
}

resource "azurerm_private_endpoint" "nodeManagement" {
  count                         = var.settings.private_endpoint != null ? 1 : 0
  name                          = "pe-${var.settings.name}-nodeManagement"
  location                      = var.settings.location
  resource_group_name           = var.settings.resource_group_name
  subnet_id                     = var.settings.private_endpoint.subnet_id
  custom_network_interface_name = "pe-nic-${var.settings.name}-nodeManagement"
  tags                          = var.settings.tags
  private_service_connection {
    name                           = "pe-${var.settings.name}-nodeManagement"
    private_connection_resource_id = azurerm_batch_account.this.id
    is_manual_connection           = false
    subresource_names              = ["nodeManagement"]
  }
  dynamic "private_dns_zone_group" {
    for_each = var.settings.private_endpoint.private_dns_zone_ids != null ? ["enabled"] : []
    content {
      name                 = "pe-${var.settings.name}-nodeManagement-dns-zone-group"
      private_dns_zone_ids = var.settings.private_endpoint.private_dns_zone_ids
    }
  }
}