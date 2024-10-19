resource "azurerm_network_watcher_flow_log" "this" {
  network_watcher_name      = var.settings.network_watcher_name
  resource_group_name       = var.settings.resource_group_name
  name                      = var.settings.name
  network_security_group_id = var.settings.network_security_group_id
  storage_account_id        = var.settings.storage_account_id
  enabled                   = var.settings.enabled
  version                   = 2
  tags                      = var.settings.tags

  retention_policy {
    enabled = var.settings.retention_policy.enabled
    days    = var.settings.retention_policy.days
  }

  dynamic "traffic_analytics" {
    for_each = var.settings.traffic_analytics != null ? [var.settings.traffic_analytics] : []
    content {
      enabled               = traffic_analytics.value.enabled
      workspace_id          = traffic_analytics.value.workspace_id
      workspace_region      = traffic_analytics.value.workspace_region
      workspace_resource_id = traffic_analytics.value.workspace_resource_id
      interval_in_minutes   = traffic_analytics.value.interval_in_minutes
    }

  }
}
