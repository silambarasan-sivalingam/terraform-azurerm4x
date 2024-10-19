variable "settings" {
  description = "Storage account configurations"
  type = object({
    name                                = string
    location                            = string
    resource_group_name                 = string
    pool_allocation_mode                = optional(string)
    storage_account_id                  = optional(string)
    storage_account_authentication_mode = optional(string)
    storage_account_node_identity       = optional(string)
    allowed_authentication_modes        = optional(list(string))
    tags                                = optional(map(string))
    public_network_access_enabled       = optional(bool, true)


    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

    encryption = optional(object({
      key_vault_key_id = string
    }))

    key_vault_reference = optional(object({
      id  = string
      url = string
    }))



    network_profile = optional(object({

      account_access = optional(list(object({
        default_action = string
        ip_rule = list(object({
          ip_range = string
          action   = string
        }))
      })))

      node_management_access = optional(list(object({
        default_action = string
        ip_rule = list(object({
          ip_range = string
          action   = string
        }))
      })))
    }))


    batch_application = optional(list(object({
      name            = string
      allow_updates   = optional(bool, true)
      default_version = optional(string)
      display_name    = optional(string)
    })))
    private_endpoint = optional(object({
      subnet_id            = string
      private_dns_zone_ids = optional(list(string))
      subresource_names    = optional(list(string))
    }))
  })
}
