variable "settings" {
  description = "rsv configurations"
  type = object({
    name                               = string
    location                           = string
    resource_group_name                = string
    sku                                = optional(string, "Standard")
    soft_delete_enabled                = optional(bool, true)
    storage_mode_type                  = optional(string, "GeoRedundant")
    cross_region_restore_enabled       = optional(bool, true)
    public_network_access_enabled      = optional(bool, false)
    tags                               = optional(map(string))
    immutability                       = optional(string)
    classic_vmware_replication_enabled = optional(bool)

    private_endpoint = object({
      subnet_id            = string
      private_dns_zone_ids = optional(list(string))
    })

    identity = optional(object({
      type         = string
      identity_ids = list(string)
    }))

    monitoring = optional(object({
      alerts_for_all_job_failures_enabled            = bool
      alerts_for_critical_operation_failures_enabled = bool
    }))

    encryption = optional(object({
      key_id                            = string
      infrastructure_encryption_enabled = optional(bool)
      user_assigned_identity_id         = string
      use_system_assigned_identity      = optional(bool)
    }))

    backup_policy_vm = optional(list(object({
      name                           = string
      timezone                       = string
      policy_type                    = optional(string)
      instant_restore_retention_days = optional(number)

      backup = object({
        frequency = string
        time      = string
        weekdays  = optional(list(string))
      })

      retention_daily = optional(object({
        count = number
      }))

      retention_weekly = optional(object({
        count    = number
        weekdays = list(string)
      }))
    })))

    backup_protected_vm = optional(list(object({
      source_vm_id     = string
      backup_policy_id = string
    })))

    backup_container_storage_account = optional(list(object({
      storage_account_id = string
    })))



  })
}
