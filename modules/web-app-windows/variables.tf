variable "settings" {
  description = "Configuration settings for azurerm_windows_web_app resources."

  type = object({
    name                                           = string
    resource_group_name                            = string
    location                                       = string
    service_plan_id                                = string
    client_certificate_enabled                     = optional(bool)
    client_certificate_mode                        = optional(string)
    client_certificate_exclusion_paths             = optional(list(string))
    ftp_publish_basic_authentication_enabled       = optional(bool)
    https_only                                     = optional(bool)
    public_network_access_enabled                  = optional(bool)
    webdeploy_publish_basic_authentication_enabled = optional(bool)
    zip_deploy_file                                = optional(bool)
    app_settings                                   = optioanl(map(string))
    enabled                                        = optional(bool)
    key_vault_reference_identity_id                = optional(string)

    site_config = optional(object({
      always_on                                     = optioanl(bool)
      api_definition_url                            = optional(string)
      api_management_api_id                         = optioanl(string)
      container_registry_managed_identity_client_id = optional(string)
      app_command_line                              = optional(string)
      container_registry_use_managed_identity       = optional(bool)
      default_documents                             = optioanl(list(string))
      ftps_state                                    = optional(string)
      health_check_path                             = optional(string)
      health_check_eviction_time_in_min             = optional(number)
      http2_enabled                                 = optioanl(bool)
      load_balancing_mode                           = optional(string)
      local_mysql_enabled                           = optional(bool)
      managed_pipeline_mode                         = optional(string)
      minimum_tls_version                           = optional(string)
      remote_debugging_enabled                      = optional(bool)
      remote_debugging_version                      = optional(string)
      auto_heal_enabled                             = optional(bool)

      application_stack = optional(object({
        current_stack                = optional(string)
        docker_image_name            = optional(string)
        docker_registry_url          = optional(string)
        docker_registry_username     = optional(string)
        docker_registry_password     = optional(string)
        docker_container_name        = optional(string)
        docker_container_tag         = optional(string)
        dotnet_version               = optional(string)
        dotnet_core_version          = optional(string)
        tomcat_version               = optional(string)
        java_embedded_server_enabled = optional(bool)
        java_version                 = optional(string)
        node_version                 = optional(string)
        php_version                  = optional(string)
        python                       = optional(string)
      }))
    }))

    identity = optional(object({
      type         = string
      identity_ids = list(string)
    }))

    backup = optional(object({
      name                = string
      storage_account_url = string
      enabled             = bool

      schedule = optional(object({
        frequency_interval       = number
        frequency_unit           = string
        keep_at_least_one_backup = bool
        retention_period_days    = number
        start_time               = string
      }))
    }))

    connection_string = optional(list(object({
      name  = string
      type  = string
      value = string
    })))

    logs = optional(object({
      detailed_error_messages = bool
      failed_request_tracing  = bool

      http_logs = optional(object({
        azure_blob_storage = optional(object({
          retention_in_days = int
          sas_url           = string
        }))
        file_system = optional(object({
          retention_in_days = int
          retention_in_mb   = int
        }))
      }))

      application_logs = optional(object({
        azure_blob_storage = optional(object({
          level             = string
          retention_in_days = int
          sas_url           = string
        }))
        file_system_level = string
      }))
    }))

    sticky_settings = optional(object({
      app_setting_names       = list(string)
      connection_string_names = list(string)
    }))

    storage_account = optional(list(object({
      access_key   = string
      account_name = string
      name         = string
      share_name   = string
      type         = string
      mount_path   = string
    })))

    virtual_network_subnet_id = optional(string)

    private_endpoint = optional(object({
      subnet_id            = string
      private_dns_zone_ids = list(string)
    }))

    tags = map(string)
  })
}
