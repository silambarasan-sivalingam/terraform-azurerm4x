variable "settings" {
  description = "azurerm_data_protection_backup_vault configuration."
  type = object({
    name                       = string
    location                   = string
    resource_group_name        = string
    datastore_type             = string
    redundancy                 = string
    retention_duration_in_days = optional(number)
    soft_delete                = optional(number)
    tags                       = optional(map(string))

    identity = optional(object({
      type = string
    }))

    data_protection_backup_policy_blob_storage = optional(list(object({
      name               = string
      retention_duration = string
    })))

    data_protection_backup_instance_blob_storage = optional(list(object({
      name               = string
      storage_account_id = string
      backup_policy_name = string
    })))
  })
}
