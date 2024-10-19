variable "settings" {
  description = "disk_encryption_set configuration."
  type = object({
    name                      = string
    location                  = string
    resource_group_name       = string
    key_vault_key_id          = string
    encryption_type           = optional(string, "EncryptionAtRestWithPlatformAndCustomerKeys")
    auto_key_rotation_enabled = optional(bool, true)
    tags                      = optional(map(string))

    identity = object({
      type         = optional(string, "UserAssigned")
      identity_ids = list(string)
    })
  })
}
