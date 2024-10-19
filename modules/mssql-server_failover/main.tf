resource "azurerm_mssql_failover_group" "this" {
  name      = var.settings.name
  server_id = var.settings.server_id
  databases = var.settings.databases
  tags      = var.settings.tags

  partner_server {
    id = var.settings.partner_server.id
  }

  dynamic "read_write_endpoint_failover_policy" {
    for_each = var.settings.read_write_endpoint_failover_policy != null ? var.settings.read_write_endpoint_failover_policy : []

    content {
      mode          = read_write_endpoint_failover_policy.value.mode
      grace_minutes = read_write_endpoint_failover_policy.value.grace_minutes
    }
  }


}
