variable "settings" {
  description = "Settings for the Azure Linux Web App and its related resources"

  type = object({
    name                                           = string
    location                                       = string
    resource_group_name                            = string
    service_plan_id                                = string
    client_affinity_enabled                        = optional(bool)
    client_certificate_enabled                     = optional(bool)
    client_certificate_mode                        = optional(string)
    client_certificate_exclusion_paths             = optional(string)
    ftp_publish_basic_authentication_enabled       = optional(bool)
    https_only                                     = optional(bool)
    public_network_access_enabled                  = optional(bool)
    webdeploy_publish_basic_authentication_enabled = optional(bool)
    zip_deploy_file                                = optional(string)
    key_vault_reference_identity_id                = optional(string)
    virtual_network_subnet_id                      = optional(string)
    app_settings                                   = optional(map(string))
    tags                                           = optional(map(string))

    site_config = optional(object({
      always_on                                     = optional(bool)
      api_definition_url                            = optional(string)
      api_management_api_id                         = optional(string)
      container_registry_managed_identity_client_id = optional(string)
      app_command_line                              = optional(string)
      container_registry_use_managed_identity       = optional(bool)
      default_documents                             = optional(list(string))
      ftps_state                                    = optional(string)
      health_check_path                             = optional(string)
      health_check_eviction_time_in_min             = optional(number)
      http2_enabled                                 = optional(bool)
      load_balancing_mode                           = optional(string)
      local_mysql_enabled                           = optional(bool)
      managed_pipeline_mode                         = optional(string)
      minimum_tls_version                           = optional(string)
      remote_debugging_enabled                      = optional(bool)
      remote_debugging_version                      = optional(string)
      application_stack = optional(object({
        docker_image_name        = optional(string)
        docker_registry_url      = optional(string)
        docker_registry_username = optional(string)
        docker_registry_password = optional(string)
        dotnet_version           = optional(string)
        go_version               = optional(string)
        java_server              = optional(string)
        java_server_version      = optional(string)
        java_version             = optional(string)
        node_version             = optional(string)
        php_version              = optional(string)
        python_version           = optional(string)
        ruby_version             = optional(string)
      }))
      auto_heal_enabled = optional(bool)
    }))

    identity = optional(object({
      type         = optional(string)
      identity_ids = optional(list(string))
    }))

    private_endpoint = optional(object({
      subnet_id            = string
      private_dns_zone_ids = optional(list(string))
    }))
  })
}
