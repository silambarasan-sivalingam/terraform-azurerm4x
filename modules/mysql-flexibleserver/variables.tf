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
  description = "mysql configurations"
  type = object({
    name                         = string
    location                     = string
    resource_group_name          = string
    version                      = optional(string, "8.0.21")
    delegated_subnet_id          = string
    private_dns_zone_id          = optional(string, null)
    zone                         = optional(string, "2")
    sku_name                     = optional(string, "GP_Standard_D2ds_v4")
    backup_retention_days        = optional(number, 7)
    geo_redundant_backup_enabled = optional(bool, true)
    administrator_login          = optional(string)
    create_mode                  = optional(string)
    source_server_id             = optional(string)

    high_availability = optional(object({
      mode                      = string
      standby_availability_zone = number
    }))


    customer_managed_key = optional(object({
      key_vault_key_id                  = string
      primary_user_assigned_identity_id = optional(string)
    }))


    identity = optional(object({
      type         = string
      identity_ids = list(string)
    }))

    storage = optional(object({
      auto_grow_enabled  = bool
      iops               = number
      size_gb            = number
      io_scaling_enabled = bool
      }), {
      auto_grow_enabled  = true
      iops               = 360
      size_gb            = 20
      io_scaling_enabled = true
    })

    key_vault_secret = optional(list(object({
      name         = string
      key_vault_id = string
    })))

    tenant_id = string
    firewall_rule = optional(list(object({
      name             = string
      start_ip_address = string
      end_ip_address   = string
    })))

    azurerm_mysql_flexible_server_database = list(object({
      name      = string
      collation = optional(string, "utf8mb3_unicode_ci")
      charset   = optional(string, "utf8mb3")
    }))


    tags = optional(map(string))
  })
}
