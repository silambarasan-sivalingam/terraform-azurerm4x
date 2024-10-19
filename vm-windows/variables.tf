variable "settings" {
  description = "vm configuration."
  type = object({
    name                       = string
    location                   = string
    resource_group_name        = string
    admin_username             = string
    size                       = string
    availability_set_id        = optional(string)
    enable_automatic_updates   = optional(bool, true)
    encryption_at_host_enabled = optional(bool, true)
    disk_encryption_set_id     = string
    license_type               = optional(string)
    computer_name              = optional(string)
    zone                       = optional(string)
    tags                       = optional(map(string))


    os_disk = object({
      name                      = string
      caching                   = string
      storage_account_type      = string
      disk_size_gb              = optional(string)
      write_accelerator_enabled = optional(bool, false)
    })

    data_disk = optional(list(object({
      name                 = string
      caching              = string
      lun                  = number
      storage_account_type = string
      create_option        = string
      disk_size_gb         = optional(string)
    })))

    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })

    additional_capabilities = optional(object({
      ultra_ssd_enabled = optional(bool)
    }))

    identity = optional(object({
      type         = string
      identity_ids = list(string)
    }))

    key_vault_secret = optional(list(object({
      name         = string
      key_vault_id = string
    })))

    network_interface = object({
      name                          = string
      enable_accelerated_networking = optional(bool, false)
      ip_configuration = object({
        subnet_id                     = string
        private_ip_address_allocation = optional(string, "Dynamic")
        private_ip_address            = optional(string)
        primary                       = optional(bool, true)
      })
    })

    virtual_machine_extension = optional(list(object({
      name                        = string
      publisher                   = string
      type                        = string
      type_handler_version        = string
      auto_upgrade_minor_version  = optional(bool)
      automatic_upgrade_enabled   = optional(bool)
      settings                    = optional(string)
      failure_suppression_enabled = optional(bool)
      protected_settings          = optional(string)
      provision_after_extensions  = optional(list(string))

      protected_settings_from_key_vault = optional(object({
        secret_url      = string
        source_vault_id = list(string)
      }))
    })))
  })
}
