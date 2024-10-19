resource "azurerm_windows_web_app" "this" {
  name                                           = var.settings.name
  location                                       = var.settings.location
  resource_group_name                            = var.settings.resource_group_name
  service_plan_id                                = var.settings.service_plan_id
  client_affinity_enabled                        = var.settings.client_affinity_enabled
  client_certificate_enabled                     = var.settings.client_certificate_enabled
  client_certificate_mode                        = var.settings.client_certificate_mode
  client_certificate_exclusion_paths             = var.settings.client_certificate_exclusion_paths
  ftp_publish_basic_authentication_enabled       = var.settings.ftp_publish_basic_authentication_enabled
  https_only                                     = var.settings.https_only
  public_network_access_enabled                  = var.settings.public_network_access_enabled
  webdeploy_publish_basic_authentication_enabled = var.settings.webdeploy_publish_basic_authentication_enabled
  zip_deploy_file                                = var.settings.zip_deploy_file
  app_settings                                   = var.settings.app_settings
  enabled                                        = var.settings.enabled
  key_vault_reference_identity_id                = var.settings.key_vault_reference_identity_id


  dynamic "site_config" {
    for_each = var.settings.site_config != null ? [var.settings.site_config] : []

    content {
      always_on                                     = site_config.value.always_on
      api_definition_url                            = site_config.value.api_definition_url
      api_management_api_id                         = site_config.value.api_management_api_id
      container_registry_managed_identity_client_id = site_config.value.container_registry_managed_identity_client_id
      app_command_line                              = site_config.value.app_command_line
      container_registry_use_managed_identity       = site_config.value.container_registry_use_managed_identity
      default_documents                             = site_config.value.default_documents
      ftps_state                                    = site_config.value.ftps_state
      health_check_path                             = site_config.value.health_check_path
      health_check_eviction_time_in_min             = site_config.value.health_check_eviction_time_in_min
      http2_enabled                                 = site_config.value.http2_enabled
      load_balancing_mode                           = site_config.value.load_balancing_mode
      local_mysql_enabled                           = site_config.value.local_mysql_enabled
      managed_pipeline_mode                         = site_config.value.managed_pipeline_mode
      minimum_tls_version                           = site_config.value.minimum_tls_version
      remote_debugging_enabled                      = site_config.value.remote_debugging_enabled
      remote_debugging_version                      = site_config.value.remote_debugging_version
      auto_heal_enabled                             = site_config.value.auto_heal_enabled

      dynamic "application_stack" {
        for_each = site_config.value.application_stack != null ? [site_config.value.application_stack] : []

        content {
          current_stack                = application_stack.value.current_stack
          docker_image_name            = application_stack.value.docker_image_name
          docker_registry_url          = application_stack.value.docker_registry_url
          docker_registry_username     = application_stack.value.docker_registry_username
          docker_registry_password     = application_stack.value.docker_registry_password
          docker_container_name        = application_stack.value.docker_container_name
          docker_container_tag         = application_stack.value.docker_container_tag
          dotnet_version               = application_stack.value.dotnet_version
          dotnet_core_version          = application_stack.value.dotnet_core_version
          tomcat_version               = application_stack.value.tomcat_version
          java_embedded_server_enabled = application_stack.value.java_embedded_server_enabled
          java_version                 = application_stack.value.java_version
          node_version                 = application_stack.value.node_version
          php_version                  = application_stack.value.php_version
          python                       = application_stack.value.python_version

        }
      }
    }
  }

  dynamic "identity" {
    for_each = var.settings.identity != null ? [var.settings.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "backup" {
    for_each = var.settings.backup != null ? [var.settings.backup] : []
    content {
      name                = backup.value.name
      storage_account_url = backup.value.storage_account_url
      enabled             = backup.value.enabled

      dynamic "schedule" {
        for_each = backup.value.schedule != null ? [backup.value.schedule] : []
        content {
          frequency_interval       = schedule.value.frequency_interval
          frequency_unit           = schedule.value.frequency_unit
          keep_at_least_one_backup = schedule.value.keep_at_least_one_backup
          retention_period_days    = schedule.value.retention_period_days
          start_time               = schedule.value.start_time
        }
      }

    }
  }

  dynamic "connection_string" {
    for_each = var.settings.connection_string != null ? var.settings.connection_string : []
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  dynamic "logs" {
    for_each = var.settings.logs != null ? [var.settings.logs] : []
    content {
      detailed_error_messages = log.value.detailed_error_messages
      failed_request_tracing  = log.value.failed_request_tracing

      dynamic "http_logs" {
        for_each = log.value.http_logs != null ? [log.value.http_logs] : []
        content {
          dynamic "azure_blob_storage" {
            for_each = http_logs.value.azure_blob_storage != null ? [http_logs.value.azure_blob_storage] : []
            content {

              retention_in_days = azure_blob_storage.value.retention_in_days
              sas_url           = azure_blob_storage.value.sas_url
            }
          }
          dynamic "file_system" {
            for_each = var.settings.identity != null ? [var.settings.identity] : []
            content {
              retention_in_days = file_system.value.retention_in_days
              retention_in_mb   = file_system.value.retention_in_mb
            }
          }
        }
      }

      dynamic "application_logs" {
        for_each = log.value.application_logs != null ? [log.value.application_logs] : []
        content {
          dynamic "azure_blob_storage" {
            for_each = application_logs.value.azure_blob_storage != null ? [application_logs.value.azure_blob_storage] : []
            content {
              level             = azure_blob_storage.value.level
              retention_in_days = azure_blob_storage.value.retention_in_days
              sas_url           = azure_blob_storage.value.sas_url
            }
          }
          file_system_level = application_logs.file_system_level
        }
      }
    }
  }

  dynamic "sticky_settings" {
    for_each = var.settings.sticky_settings != null ? [var.settings.sticky_settings] : []
    content {
      app_setting_names       = sticky_settings.value.app_setting_names
      connection_string_names = sticky_settings.value.connection_string_names
    }
  }

  dynamic "storage_account" {
    for_each = var.settings.storage_account != null ? var.settings.storage_account : []
    content {
      access_key   = storage_account.value.access_key
      account_name = storage_account.value.account_name
      name         = storage_account.value.name
      share_name   = storage_account.value.share_name
      type         = storage_account.value.type
      mount_path   = storage_account.mount_path

    }
  }

  tags = var.settings.tags

  lifecycle {
    ignore_changes = [virtual_network_subnet_id]
  }

}

resource "azurerm_app_service_virtual_network_swift_connection" "this" {
  app_service_id = azurerm_windows_web_app.this.id
  subnet_id      = var.settings.virtual_network_subnet_id
}

resource "azurerm_private_endpoint" "this" {
  count                         = var.settings.private_endpoint != null ? 1 : 0
  name                          = "pe-${var.settings.name}"
  location                      = var.settings.location
  resource_group_name           = var.settings.resource_group_name
  subnet_id                     = var.settings.private_endpoint.subnet_id
  custom_network_interface_name = replace("pe-${var.settings.name}", "pe-", "penic-")
  tags                          = var.settings.tags
  private_service_connection {
    name                           = "pe-${var.settings.name}"
    private_connection_resource_id = azurerm_windows_web_app.this.id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }

  dynamic "private_dns_zone_group" {
    for_each = var.settings.private_endpoint.private_dns_zone_ids != null ? ["enabled"] : []
    content {
      name                 = "pe-${var.settings.name}-dns-zone-group"
      private_dns_zone_ids = var.settings.private_endpoint.private_dns_zone_ids
    }
  }
}
