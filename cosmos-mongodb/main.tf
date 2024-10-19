resource "azurerm_cosmosdb_mongo_database" "this" {

  name                = var.settings.name
  resource_group_name = var.settings.resource_group_name
  account_name        = var.settings.account_name
  throughput          = var.settings.throughput

  dynamic "autoscale_settings" {
    for_each = var.settings.autoscale_settings != null ? [var.settings.autoscale_settings] : []
    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }
}


resource "azurerm_cosmosdb_mongo_collection" "this" {
  for_each = try({ for c in var.settings.cosmosdb_mongo_collection : c.name => c }, {})

  name                = each.key
  resource_group_name = var.settings.resource_group_name
  account_name        = var.settings.account_name
  database_name       = azurerm_cosmosdb_mongo_database.this.name
  shard_key           = each.value.shard_key
  throughput          = each.value.throughput
  default_ttl_seconds = each.value.default_ttl_seconds

  dynamic "index" {
    for_each = each.value.index != null ? each.value.index : []
    content {
      keys   = ["_id"]
      unique = true
    }

  }

  dynamic "autoscale_settings" {
    for_each = each.value.autoscale_settings != null ? [each.value.autoscale_settings] : []
    content {
      max_throughput = autoscale_settings.value.max_throughput
    }
  }
}