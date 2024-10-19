resource "azurerm_linux_web_app" "this" {
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


  key_vault_reference_identity_id = var.settings.key_vault_reference_identity_id



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

      dynamic "application_stack" {
        for_each = site_config.value.application_stack != null ? [site_config.value.application_stack] : []

        content {
          docker_image_name        = application_stack.value.docker_image_name
          docker_registry_url      = application_stack.value.docker_registry_url
          docker_registry_username = application_stack.value.docker_registry_username
          docker_registry_password = application_stack.value.docker_registry_password
          dotnet_version           = application_stack.value.dotnet_version
          go_version               = application_stack.value.go_version
          java_server              = application_stack.value.java_server
          java_server_version      = application_stack.value.java_server_version
          java_version             = application_stack.value.java_version
          node_version             = application_stack.value.node_version
          php_version              = application_stack.value.php_version
          python_version           = application_stack.value.python_version
          ruby_version             = application_stack.value.ruby_version

        }

      }

      auto_heal_enabled = site_config.value.auto_heal_enabled


    }
  }

  dynamic "identity" {
    for_each = var.settings.identity != null ? [var.settings.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }


  tags = var.settings.tags

  lifecycle {
    ignore_changes = [virtual_network_subnet_id]
  }

}


resource "azurerm_app_service_virtual_network_swift_connection" "this" {
  app_service_id = azurerm_linux_web_app.this.id
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
    private_connection_resource_id = azurerm_linux_web_app.this.id
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
