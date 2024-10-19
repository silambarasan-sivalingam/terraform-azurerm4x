variable "settings" {
  description = "mssql configuration"

  type = object({
    name                           = string
    location                       = string
    resource_group_name            = string
    administrator_login            = string
    license_type                   = string
    subnet_id                      = string
    sku_name                       = string
    vcores                         = number
    storage_size_in_gb             = number
    public_data_endpoint_enabled   = optional(bool)
    minimum_tls_version            = optional(number)
    proxy_override                 = optional(string)
    timezone_id                    = optional(string)
    key_vault_key_id               = string
    collation                      = optional(string)
    maintenance_configuration_name = optional(string)
    zone_redundant_enabled         = optional(bool)
    storage_account_type           = optional(string)
    tags                           = optional(map(string))

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

    private_endpoint = optional(object({
      subnet_id            = string
      private_dns_zone_ids = optional(list(string))
    }))

    key_vault_id = string
  })
}
