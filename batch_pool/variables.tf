variable "settings" {
  type = object({
    name                           = string
    resource_group_name            = string
    display_name                   = optional(string)
    account_name                   = string
    vm_size                        = string
    node_agent_sku_id              = string
    target_node_communication_mode = optional(string, "Default")
    auto_scale = optional(object({
      evaluation_interval = string
      formula             = string
    }))
    fixed_scale = optional(object({
      node_deallocation_method  = optional(string, "Requeue")
      target_dedicated_nodes    = optional(number, 1)
      target_low_priority_nodes = optional(number, null)
      resize_timeout            = optional(string, "PT15M")
    }))

    storage_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }))
    network_configuration = optional(object({
      subnet_id                        = string
      dynamic_vnet_assignment_scope    = optional(string)
      accelerated_networking_enabled   = optional(bool, false)
      public_ips                       = optional(list(string))
      public_address_provisioning_type = optional(string)
      endpoint_configuration = optional(object({
        name                = string
        backend_port        = string
        protocol            = string
        frontend_port_range = string
      }))
    }))

    container_configuration = optional(object({
      type = string
      container_registries = list(object({
        registry_server = string
        user_name       = string
        password        = string
      }))
    }))

    start_task = optional(object({
      command_line                  = string
      task_retry_maximum            = optional(number)
      wait_for_success              = optional(bool)
      common_environment_properties = optional(map(string))
      user_identity = object({
        auto_user = object({
          elevation_level = string
          scope           = string
        })
      })
      resource_file = optional(object({
        auto_storage_container_name = optional(string)
        blob_prefix                 = optional(string)
        file_mode                   = optional(string)
        file_path                   = optional(string)
        http_url                    = optional(string)
        storage_container_url       = optional(string)
        user_assigned_identity_id   = optional(string)
      }))
    }))

    certificate = optional(object({
      id             = string
      store_location = string
      visibility     = list(string)
    }))

  })
}
