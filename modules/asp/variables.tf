variable "settings" {
  description = "App Service Plan configuration."
  type = object({
    name                         = string
    location                     = string
    resource_group_name          = string
    os_type                      = string
    sku_name                     = string
    app_service_environment_id   = optional(string)
    maximum_elastic_worker_count = optional(string)
    worker_count                 = optional(number)
    per_site_scaling_enabled     = optional(bool)
    zone_balancing_enabled       = optional(bool)
    tags                         = optional(map(string), null)
  })
}
