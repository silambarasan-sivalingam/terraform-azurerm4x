resource "azurerm_linux_function_app" "this" {
  name                          = var.settings.name
  location                      = var.settings.location
  resource_group_name           = var.settings.resource_group_name
  service_plan_id               = var.settings.service_plan_id
  storage_account_name          = var.settings.storage_account_name
  storage_account_access_key    = var.settings.storage_account_access_key
  public_network_access_enabled = var.settings.public_network_access_enabled

  site_config {
    application_stack {
      python_version          = var.settings.application_stack.python_version != null ? var.settings.application_stack.python_version : null
      node_version            = var.settings.application_stack.node_version != null ? var.settings.application_stack.node_version : null
      powershell_core_version = var.settings.application_stack.powershell_core_version != null ? var.settings.application_stack.powershell_core_version : null
    }
  }

  app_settings = var.settings.app_settings

  lifecycle {
    ignore_changes = [virtual_network_subnet_id,
      # storage_account_access_key,
      sticky_settings,
      app_settings,
      # storage_account_name,
      tags,
      site_config,
      storage_key_vault_secret_id,
      https_only,
    builtin_logging_enabled]
  }
  tags = var.settings.tags

  dynamic "identity" {
    for_each = var.settings.identity != null ? [var.settings.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  key_vault_reference_identity_id = var.settings.key_vault_reference_identity_id
}


resource "azurerm_app_service_virtual_network_swift_connection" "this" {
  app_service_id = azurerm_linux_function_app.this.id
  subnet_id      = var.settings.virtual_network_subnet_id
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
    private_connection_resource_id = azurerm_linux_function_app.this.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.settings.private_endpoint.private_dns_zone_ids != null ? ["enabled"] : []
    content {
      name                 = "pe-${var.settings.name}-dns-zone-group"
      private_dns_zone_ids = var.settings.private_endpoint.private_dns_zone_ids
    }
  }
}

# resource "azurerm_monitor_diagnostic_setting" "this" {
#   name               = "${var.settings.name}-ds"
#   target_resource_id = azurerm_application_insights.this.id
#   storage_account_id = var.settings.storage_account_id

#   # enabled_log {
#   #   category = "AuditEvent"

#   #   retention_policy {
#   #     enabled = false
#   #   }
#   # }

#   metric {
#     category = "AllMetrics"

#     # retention_policy {
#     #   enabled = false
#     # }
#   }
# }
