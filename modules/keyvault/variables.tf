

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
  description = "Key vault configuration."
  type = object({
    azurerm_key_vault_name          = string
    location                        = string
    resource_group_name             = string
    sku_name                        = optional(string, "premium")
    purge_protection_enabled        = optional(bool, false)
    tags                            = optional(map(string), null)
    enabled_for_disk_encryption     = optional(bool, true)
    tenant_id                       = string
    soft_delete_retention_days      = optional(number)
    enabled_for_template_deployment = optional(bool)
    enabled_for_deployment          = optional(bool)
    enable_rbac_authorization       = optional(bool)
    public_network_access_enabled   = optional(bool)
    secret_expiration_date          = optional(string)


    network_acls = optional(list(object({
      bypass                     = string
      default_action             = string
      ip_rules                   = optional(list(string))
      virtual_network_subnet_ids = optional(list(string))
    })))

    key_vault_key = optional(list(object({
      name     = string
      key_type = optional(string, "RSA-HSM")
      key_size = optional(number, 2048)
      key_opts = optional(list(string), [
        "decrypt",
        "encrypt",
        "sign",
        "unwrapKey",
        "verify",
        "wrapKey"
      ])
      expiration_date = optional(string)

      # rotation_policy = optional(list(object({
      #   time_before_expiry   = optional(string, "P20D")
      #   expire_after         = optional(string, "P24M")
      #   notify_before_expiry = optional(string, "P30D")

      # })))
    })))

    vm_ssh_generate = optional(list(object({
      name = string
    })))


    private_endpoint = optional(object({
      subnet_id            = string
      private_dns_zone_ids = optional(list(string))
    }))
  })
}
