resource "azurerm_service_plan" "this" {
  name                         = var.settings.name
  resource_group_name          = var.settings.resource_group_name
  location                     = var.settings.location
  os_type                      = var.settings.os_type
  sku_name                     = var.settings.sku_name
  app_service_environment_id   = var.settings.app_service_environment_id
  maximum_elastic_worker_count = var.settings.maximum_elastic_worker_count
  worker_count                 = var.settings.worker_count
  per_site_scaling_enabled     = var.settings.per_site_scaling_enabled
  zone_balancing_enabled       = var.settings.zone_balancing_enabled
  tags                         = var.settings.tags
}
