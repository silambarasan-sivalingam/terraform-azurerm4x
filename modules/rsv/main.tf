resource "azurerm_recovery_services_vault" "this" {
  name                               = var.settings.name
  location                           = var.settings.location
  resource_group_name                = var.settings.resource_group_name
  sku                                = var.settings.sku
  soft_delete_enabled                = var.settings.soft_delete_enabled
  public_network_access_enabled      = var.settings.public_network_access_enabled
  storage_mode_type                  = var.settings.storage_mode_type
  cross_region_restore_enabled       = var.settings.cross_region_restore_enabled
  immutability                       = var.settings.immutability
  classic_vmware_replication_enabled = var.settings.classic_vmware_replication_enabled

  dynamic "identity" {
    for_each = var.settings.identity != null ? [var.settings.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "monitoring" {
    for_each = var.settings.monitoring != null ? [var.settings.monitoring] : []
    content {
      alerts_for_all_job_failures_enabled               = monitoring.value.alerts_for_all_job_failures_enabled
      alerts_for_critical_operation_failures_enabled    = monitoring.value.alerts_for_critical_operation_failures_enabled
    }
  }

  dynamic "encryption" {
    for_each = var.settings.encryption != null ? [var.settings.encryption] : []
    content {
      key_id                            = encryption.value.key_id
      infrastructure_encryption_enabled = encryption.value.infrastructure_encryption_enabled
      user_assigned_identity_id         = encryption.value.user_assigned_identity_id
      use_system_assigned_identity      = encryption.value.use_system_assigned_identity
    }

  }
  tags = var.settings.tags
}

resource "azurerm_private_endpoint" "this" {
  name                          = "pe-${var.settings.name}"
  location                      = var.settings.location
  resource_group_name           = var.settings.resource_group_name
  subnet_id                     = var.settings.private_endpoint.subnet_id
  custom_network_interface_name = replace(var.settings.name, "pe-", "penic-")
  private_service_connection {
    name                           = "pe-${var.settings.name}"
    private_connection_resource_id = azurerm_recovery_services_vault.this.id
    is_manual_connection           = false
    subresource_names              = ["AzureBackup"]
  }

  private_dns_zone_group {
    name                 = "${var.settings.name}-dns-zone-group"
    private_dns_zone_ids = var.settings.private_endpoint.private_dns_zone_ids
  }
  tags = var.settings.tags
}

resource "azurerm_backup_policy_vm" "this" {
  for_each                       = try({ for n in var.settings.backup_policy_vm : n.name => n }, {})
  name                           = each.key
  resource_group_name            = var.settings.resource_group_name
  recovery_vault_name            = azurerm_recovery_services_vault.this.name
  policy_type                    = each.value.policy_type
  instant_restore_retention_days = each.value.instant_restore_retention_days

  timezone = each.value.timezone

  dynamic "backup" {

    for_each = each.value.backup != null ? [each.value.backup] : []

    content {
      frequency = backup.value.frequency
      time      = backup.value.time
      weekdays  = backup.value.weekdays
    }

  }

  dynamic "retention_daily" {

    for_each = each.value.retention_daily != null ? [each.value.retention_daily] : []
    content {
      count = each.value.retention_daily.count
    }
  }

  dynamic "retention_weekly" {

    for_each = each.value.retention_weekly != null ? [each.value.retention_weekly] : []
    content {
      count    = each.value.retention_weekly.count
      weekdays = each.value.retention_weekly.weekdays
    }

  }

}


resource "azurerm_backup_protected_vm" "this" {
  for_each = try({
    for np in var.settings.backup_protected_vm :
    "${basename(np.source_vm_id)}_${basename(np.backup_policy_id)}" => np
  }, {})
  resource_group_name = var.settings.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.this.name
  source_vm_id        = each.value.source_vm_id
  backup_policy_id    = each.value.backup_policy_id

}

// resource "azurerm_backup_container_storage_account" "container" {
//   for_each            = try({ for n in var.settings.backup_container_storage_account : n.storage_account_id => n }, {})
//   resource_group_name = var.settings.resource_group_name
//   recovery_vault_name = azurerm_recovery_services_vault.this.name
//   storage_account_id  = each.key

// }
