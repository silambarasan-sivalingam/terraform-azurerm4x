variable "settings" {
  type = object({
    name                      = string
    location                  = string
    resource_group_name       = string
    network_watcher_name      = string
    network_security_group_id = string
    storage_account_id        = string
    enabled                   = optional(bool, true)
    tags                      = optional(map(string), null)

    retention_policy = optional(object({
      enabled = optional(bool, true)
      days    = optional(number, 90)
    }), {})

    traffic_analytics = optional(object({
      enabled               = optional(bool, true)
      workspace_id          = string
      workspace_region      = string
      workspace_resource_id = string
      interval_in_minutes   = optional(number, 10)
    }))
  })
}
