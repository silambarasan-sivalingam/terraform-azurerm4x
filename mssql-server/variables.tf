variable "expiry_hours" {
  description = "The expiry hours for the encryption key"
  type        = string
  default     = "17520h" // 2 years from activation date
}

locals {

  current_time    = timestamp()
  expiration_date = timeadd(local.current_time, var.expiry_hours)
}


variable "settings" {
  description = "mssql configuration"

  type = object({
    name                                         = string
    location                                     = string
    resource_group_name                          = string
    version                                      = optional(string, "12.0")
    connection_policy                            = optional(string)
    minimum_tls_version                          = optional(string, "1.2")
    public_network_access_enabled                = optional(bool)
    outbound_network_restriction_enabled         = optional(bool)
    administrator_login                          = optional(string)
    primary_user_assigned_identity_id            = optional(string)
    transparent_data_encryption_key_vault_key_id = optional(string)
    tags                                         = optional(map(string))


    identity = optional(object({
      type         = string
      identity_ids = list(string)
    }))

    key_vault_secret = optional(list(object({
      name         = string
      key_vault_id = string
    })))

    azuread_administrator = optional(object({
      login_username              = string
      object_id                   = string
      tenant_id                   = optional(string)
      azuread_authentication_only = optional(bool)
    }))



    elasticpool = optional(list(object({

      name           = optional(string)
      license_type   = optional(string)
      max_size_gb    = optional(string)
      max_size_bytes = optional(string)

      per_database_settings = optional(object({
        max_capacity = optional(number)
        min_capacity = optional(number)
      }))

      sku = optional(object({
        capacity = optional(number)
        name     = optional(string)
        tier     = optional(string)
        family   = optional(string)
      }))

    })))

    virtual_network_rule = optional(list(object({
      name      = string
      subnet_id = string
    })), [])

    mssql_database = optional(list(object({
      name                                         = string
      collation                                    = optional(string)
      license_type                                 = optional(string)
      max_size_gb                                  = number
      read_scale                                   = optional(bool)
      sku_name                                     = optional(string)
      transparent_data_encryption_key_vault_key_id = optional(string)

      identity = optional(object({
        type         = string
        identity_ids = list(string)
      }))

      threat_detection_policy = optional(object({
        state                      = string
        storage_endpoint           = string
        storage_account_access_key = string
        retention_days             = string
        email_addresses            = string
      }))


      long_term_retention_policy = optional(object({
        weekly_retention          = string
        monthly_retention         = string
        yearly_retention          = string
        week_of_year              = string
        immutable_backups_enabled = string
      }))

      short_term_retention_policy = optional(object({
        retention_days           = string
        backup_interval_in_hours = string

      }))

    })))

    mssql_firewall_rule = optional(list(object({
      name             = string
      start_ip_address = string
      end_ip_address   = string
    })))


    private_endpoint = optional(object({
      subnet_id            = string
      private_dns_zone_ids = optional(list(string))
    }))

  })
}
