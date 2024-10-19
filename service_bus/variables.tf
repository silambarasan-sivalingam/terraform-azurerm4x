variable "settings" {
  description = "servicebus namespace configuration"
 
  type = object({
    name                          = string
    location                      = string
    resource_group_name           = string
    sku                           = optional(string, "Premium")
    local_auth_enabled            = optional(bool, true)
    minimum_tls_version           = optional(string, "1.2")
    zone_redundant                = optional(bool, true)
    capacity                      = number
    premium_messaging_partitions  = optional(number, 1)
    public_network_access_enabled = optional(bool, false)
    identity = object({
      type         = string
      identity_ids = optional(list(string))
    })
 
    network_rule_set = optional(object({
      default_action           = optional(string, "Allow")
      trusted_services_allowed = optional(bool, true)
      ip_rules                 = optional(list(string), [])
      public_network_access_enabled = optional(bool, false)
 
      network_rules = optional(object({
        subnet_id                            = string
        ignore_missing_vnet_service_endpoint = optional(bool, true)
      }))
    }))
  
    customer_managed_key = optional(object({
      key_vault_key_id                            = string
      identity_id                      = string
     infrastructure_encryption_enabled = optional(bool, true)
    }))

    servicebus_queue = optional(list(object({
      name             = string
      requires_session = optional(bool, false)
    })))
 
    private_endpoint = object({
      subnet_id            = string
      private_dns_zone_ids = optional(list(string))
    })
    autoscale_setting = optional(object({
        name = string
        rule = list(object(
          {
            metric_trigger = object({
              metric_name      = string
              time_grain       = string
              statistic        = string
              time_window      = string
              time_aggregation = string
              operator         = string
              threshold        = number
            })

            scale_action = object({
              direction = string
              type      = string
              value     = string
              cooldown  = string
            })
          }
        ))

        /*predictive = optional(object({
          scale_mode      = optional(string, "Enabled")
          look_ahead_time = optional(string, "PT5M")
        }))*/
    }))
    tags = optional(map(string))
 
  })
}
 
