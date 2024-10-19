resource "azurerm_batch_pool" "this" {
  name                           = var.settings.name
  resource_group_name            = var.settings.resource_group_name
  account_name                   = var.settings.account_name
  display_name                   = var.settings.display_name
  vm_size                        = var.settings.vm_size
  node_agent_sku_id              = var.settings.node_agent_sku_id
  target_node_communication_mode = var.settings.target_node_communication_mode

  dynamic "auto_scale" {
    for_each = var.settings.auto_scale != null ? [var.settings.auto_scale] : []
    content {
      evaluation_interval = auto_scale.value.evaluation_interval
      formula             = auto_scale.value.formula
    }
  }

  dynamic "fixed_scale" {
    for_each = var.settings.fixed_scale != null ? [var.settings.fixed_scale] : []
    content {
      node_deallocation_method  = fixed_scale.value.node_deallocation_method
      target_dedicated_nodes    = fixed_scale.value.target_dedicated_nodes
      target_low_priority_nodes = fixed_scale.value.target_low_priority_nodes
      #resize_timeout             = fixed_scale.value.resize_timeout
    }
  }

  dynamic "storage_image_reference" {
    for_each = var.settings.storage_image_reference != null ? [var.settings.storage_image_reference] : []
    content {
      publisher = storage_image_reference.value.publisher
      offer     = storage_image_reference.value.offer
      sku       = storage_image_reference.value.sku
      version   = storage_image_reference.value.version
    }
  }

  dynamic "network_configuration" {
    for_each = var.settings.network_configuration != null ? [var.settings.network_configuration] : []
    content {
      subnet_id                        = network_configuration.value.subnet_id
      dynamic_vnet_assignment_scope    = network_configuration.value.dynamic_vnet_assignment_scope
      accelerated_networking_enabled   = network_configuration.value.accelerated_networking_enabled
      public_ips                       = network_configuration.value.public_ips
      public_address_provisioning_type = network_configuration.value.public_address_provisioning_type
    }
  }

  dynamic "container_configuration" {
    for_each = var.settings.container_configuration != null ? [var.settings.container_configuration] : []
    content {
      type = container_configuration.value.type

      dynamic "container_registries" {
        for_each = container_configuration.value.container_registries != null ? container_configuration.value.container_registries : []
        content {
          registry_server = container_registries.value.registry_server
          user_name       = container_registries.value.user_name
          password        = container_registries.value.password
        }
      }
    }
  }

  dynamic "start_task" {
    for_each = var.settings.start_task != null ? [var.settings.start_task] : []
    content {
      command_line       = start_task.value.command_line
      task_retry_maximum = start_task.value.task_retry_maximum
      wait_for_success   = start_task.value.wait_for_success

      common_environment_properties = start_task.value.common_environment_properties

      dynamic "user_identity" {
        for_each = start_task.value.user_identity != null ? [start_task.value.user_identity] : []
        content {
          auto_user {
            elevation_level = user_identity.value.auto_user.elevation_level
            scope           = user_identity.value.auto_user.scope
          }
        }
      }
      dynamic "resource_file" {
        for_each = start_task.value.resource_file != null ? [start_task.value.resource_file] : []
        content {
          auto_storage_container_name = resource_file.value.auto_storage_container_name
          blob_prefix                 = resource_file.value.blob_prefix
          file_mode                   = resource_file.value.file_mode
          file_path                   = resource_file.value.file_path
          http_url                    = resource_file.value.http_url
          storage_container_url       = resource_file.value.storage_container_url
          user_assigned_identity_id   = resource_file.value.user_assigned_identity_id
        }
      }
    }
  }

  dynamic "certificate" {
    for_each = var.settings.certificate != null ? [var.settings.certificate] : []
    content {
      id             = certificate.value.id
      store_location = certificate.value.store_location
      visibility     = certificate.value.visibility
    }
  }
}
