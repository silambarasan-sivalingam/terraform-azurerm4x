
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  name                                = var.settings.name
  location                            = var.settings.location
  resource_group_name                 = var.settings.resource_group_name
  automatic_channel_upgrade           = var.settings.automatic_channel_upgrade
  azure_policy_enabled                = var.settings.azure_policy_enabled
  disk_encryption_set_id              = var.settings.disk_encryption_set_id
  dns_prefix                          = var.settings.dns_prefix
  dns_prefix_private_cluster          = var.settings.dns_prefix_private_cluster
  image_cleaner_enabled               = var.settings.image_cleaner_enabled
  image_cleaner_interval_hours        = var.settings.image_cleaner_interval_hours
  kubernetes_version                  = var.settings.kubernetes_version
  local_account_disabled              = var.settings.local_account_disabled
  node_os_channel_upgrade             = var.settings.node_os_channel_upgrade
  node_resource_group                 = var.settings.node_resource_group
  oidc_issuer_enabled                 = var.settings.oidc_issuer_enabled
  open_service_mesh_enabled           = var.settings.open_service_mesh_enabled
  private_cluster_enabled             = var.settings.private_cluster_enabled
  private_cluster_public_fqdn_enabled = var.settings.private_cluster_public_fqdn_enabled
  private_dns_zone_id                 = var.settings.private_dns_zone_id
  role_based_access_control_enabled   = var.settings.role_based_access_control_enabled
  run_command_enabled                 = var.settings.run_command_enabled
  sku_tier                            = var.settings.sku_tier
  support_plan                        = var.settings.support_plan
  tags                                = var.settings.tags
  workload_identity_enabled           = var.settings.workload_identity_enabled
  custom_ca_trust_certificates_base64 = var.settings.custom_ca_trust_certificates_base64
  edge_zone                           = var.settings.edge_zone
  http_application_routing_enabled    = var.settings.http_application_routing_enabled


  dynamic "confidential_computing" {
    for_each = var.settings.confidential_computing != null ? [var.settings.confidential_computing] : []
    content {
      sgx_quote_helper_enabled = confidential_computing.value.sgx_quote_helper_enabled
    }
  }

  dynamic "default_node_pool" {
    for_each = var.settings.default_node_pool != null ? [var.settings.default_node_pool] : []

    content {
      name                         = default_node_pool.value.name
      vm_size                      = default_node_pool.value.vm_size
      enable_auto_scaling          = default_node_pool.value.enable_auto_scaling
      enable_host_encryption       = default_node_pool.value.enable_host_encryption
      enable_node_public_ip        = default_node_pool.value.enable_node_public_ip
      fips_enabled                 = default_node_pool.value.fips_enabled
      max_count                    = default_node_pool.value.max_count
      max_pods                     = default_node_pool.value.max_pods
      node_count                   = default_node_pool.value.node_count
      min_count                    = default_node_pool.value.min_count
      node_labels                  = default_node_pool.value.node_labels
      only_critical_addons_enabled = default_node_pool.value.only_critical_addons_enabled
      orchestrator_version         = default_node_pool.value.orchestrator_version
      os_disk_size_gb              = default_node_pool.value.os_disk_size_gb
      os_disk_type                 = default_node_pool.value.os_disk_type
      os_sku                       = default_node_pool.value.os_sku
      pod_subnet_id                = default_node_pool.value.pod_subnet_id
      proximity_placement_group_id = default_node_pool.value.proximity_placement_group_id
      scale_down_mode              = default_node_pool.value.scale_down_mode
      snapshot_id                  = default_node_pool.value.snapshot_id
      tags                         = var.settings.tags
      temporary_name_for_rotation  = default_node_pool.value.temporary_name_for_rotation
      type                         = default_node_pool.value.type
      ultra_ssd_enabled            = default_node_pool.value.ultra_ssd_enabled
      vnet_subnet_id               = default_node_pool.value.vnet_subnet_id
      zones                        = default_node_pool.value.zones

      dynamic "upgrade_settings" {
        for_each = default_node_pool.value.upgrade_settings != null ? [default_node_pool.value.upgrade_settings] : []

        content {
          max_surge                     = upgrade_settings.value.max_surge
          drain_timeout_in_minutes      = upgrade_settings.value.drain_timeout_in_minutes
          node_soak_duration_in_minutes = upgrade_settings.value.node_soak_duration_in_minutes

        }
      }

      # dynamic "kubelet_config" {
      #   for_each = default_node_pool.value.kubelet_config != null ? [default_node_pool.value.kubelet_config] : []

      #   content {
      #     allowed_unsafe_sysctls    = kubelet_config.value.allowed_unsafe_sysctls
      #     container_log_max_line    = kubelet_config.value.container_log_max_line
      #     container_log_max_size_mb = kubelet_config.value.container_log_max_size_mb
      #     cpu_cfs_quota_enabled     = kubelet_config.value.cpu_cfs_quota_enabled
      #     cpu_cfs_quota_period      = kubelet_config.value.cpu_cfs_quota_period
      #     cpu_manager_policy        = kubelet_config.value.cpu_manager_policy
      #     image_gc_high_threshold   = kubelet_config.value.image_gc_high_threshold
      #     image_gc_low_threshold    = kubelet_config.value.image_gc_low_threshold
      #     pod_max_pid               = kubelet_config.value.pod_max_pid
      #     topology_manager_policy   = kubelet_config.value.topology_manager_policy
      #   }
      # }

      # dynamic "linux_os_config" {
      #   for_each = default_node_pool.value.linux_os_config != null ? [default_node_pool.value.linux_os_config] : []

      #   content {
      #     swap_file_size_mb             = linux_os_config.value.swap_file_size_mb
      #     transparent_huge_page_defrag  = linux_os_config.value.transparent_huge_page_defrag
      #     transparent_huge_page_enabled = linux_os_config.value.transparent_huge_page_enabled

      #     dynamic "sysctl_config" {
      #       for_each = linux_os_config.value.sysctl_configs != null ? [linux_os_config.value.sysctl_configs] : []

      #       content {
      #         fs_aio_max_nr                      = sysctl_config.value.fs_aio_max_nr
      #         fs_file_max                        = sysctl_config.value.fs_file_max
      #         fs_inotify_max_user_watches        = sysctl_config.value.fs_inotify_max_user_watches
      #         fs_nr_open                         = sysctl_config.value.fs_nr_open
      #         kernel_threads_max                 = sysctl_config.value.kernel_threads_max
      #         net_core_netdev_max_backlog        = sysctl_config.value.net_core_netdev_max_backlog
      #         net_core_optmem_max                = sysctl_config.value.net_core_optmem_max
      #         net_core_rmem_default              = sysctl_config.value.net_core_rmem_default
      #         net_core_rmem_max                  = sysctl_config.value.net_core_rmem_max
      #         net_core_somaxconn                 = sysctl_config.value.net_core_somaxconn
      #         net_core_wmem_default              = sysctl_config.value.net_core_wmem_default
      #         net_core_wmem_max                  = sysctl_config.value.net_core_wmem_max
      #         net_ipv4_ip_local_port_range_max   = sysctl_config.value.net_ipv4_ip_local_port_range_max
      #         net_ipv4_ip_local_port_range_min   = sysctl_config.value.net_ipv4_ip_local_port_range_min
      #         net_ipv4_neigh_default_gc_thresh1  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh1
      #         net_ipv4_neigh_default_gc_thresh2  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh2
      #         net_ipv4_neigh_default_gc_thresh3  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh3
      #         net_ipv4_tcp_fin_timeout           = sysctl_config.value.net_ipv4_tcp_fin_timeout
      #         net_ipv4_tcp_keepalive_intvl       = sysctl_config.value.net_ipv4_tcp_keepalive_intvl
      #         net_ipv4_tcp_keepalive_probes      = sysctl_config.value.net_ipv4_tcp_keepalive_probes
      #         net_ipv4_tcp_keepalive_time        = sysctl_config.value.net_ipv4_tcp_keepalive_time
      #         net_ipv4_tcp_max_syn_backlog       = sysctl_config.value.net_ipv4_tcp_max_syn_backlog
      #         net_ipv4_tcp_max_tw_buckets        = sysctl_config.value.net_ipv4_tcp_max_tw_buckets
      #         net_ipv4_tcp_tw_reuse              = sysctl_config.value.net_ipv4_tcp_tw_reuse
      #         net_netfilter_nf_conntrack_buckets = sysctl_config.value.net_netfilter_nf_conntrack_buckets
      #         net_netfilter_nf_conntrack_max     = sysctl_config.value.net_netfilter_nf_conntrack_max
      #         vm_max_map_count                   = sysctl_config.value.vm_max_map_count
      #         vm_swappiness                      = sysctl_config.value.vm_swappiness
      #         vm_vfs_cache_pressure              = sysctl_config.value.vm_vfs_cache_pressure
      #       }
      # }
      # }
      # }


    }
  }


  dynamic "key_vault_secrets_provider" {
    for_each = var.settings.key_vault_secrets_provider != null ? [var.settings.key_vault_secrets_provider] : []
    content {
      secret_rotation_enabled  = key_vault_secrets_provider.value.secret_rotation_enabled
      secret_rotation_interval = key_vault_secrets_provider.value.secret_rotation_interval
    }
  }

  dynamic "identity" {
    for_each = var.settings.identity != null ? [var.settings.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  # dynamic "service_principal" {
  #   for_each = var.settings.service_principal != null ? [var.settings.service_principal] : []
  #   content {
  #     client_id     = service_principal.value.client_id
  #     client_secret = service_principal.value.client_secret
  #   }
  # }

  # dynamic "ssh_key" {
  #   for_each = var.settings.ssh_key != null ? [var.settings.ssh_key] : []
  #   content {
  #     key_data = ssh_key.value.key_data
  #   }
  # }

  dynamic "storage_profile" {
    for_each = var.settings.storage_profile != null ? [var.settings.storage_profile] : []
    content {
      blob_driver_enabled         = storage_profile.value.blob_driver_enabled
      disk_driver_enabled         = storage_profile.value.disk_driver_enabled
      disk_driver_version         = storage_profile.value.disk_driver_version
      file_driver_enabled         = storage_profile.value.file_driver_enabled
      snapshot_controller_enabled = storage_profile.value.snapshot_controller_enabled
    }
  }

  # dynamic "aci_connector_linux" {
  #   for_each = var.settings.aci_connector_linux != null ? [var.settings.aci_connector_linux] : []

  #   content {
  #     subnet_name = aci_connector_linux.value.subnet_name
  #   }
  # }


  dynamic "api_server_access_profile" {
    for_each = var.settings.api_server_access_profile != null ? [var.settings.api_server_access_profile] : []

    content {
      authorized_ip_ranges     = api_server_access_profile.value.authorized_ip_ranges
      subnet_id                = api_server_access_profile.value.subnet_id
      vnet_integration_enabled = api_server_access_profile.value.vnet_integration_enabled
    }
  }

  # dynamic "auto_scaler_profile" {
  #   for_each = var.settings.auto_scaler_profile != null ? [var.settings.auto_scaler_profile] : []

  #   content {
  #     balance_similar_node_groups      = auto_scaler_profile.value.balance_similar_node_groups
  #     empty_bulk_delete_max            = auto_scaler_profile.value.empty_bulk_delete_max
  #     expander                         = auto_scaler_profile.value.expander
  #     max_graceful_termination_sec     = auto_scaler_profile.value.max_graceful_termination_sec
  #     max_node_provisioning_time       = auto_scaler_profile.value.max_node_provisioning_time
  #     max_unready_nodes                = auto_scaler_profile.value.max_unready_nodes
  #     max_unready_percentage           = auto_scaler_profile.value.max_unready_percentage
  #     new_pod_scale_up_delay           = auto_scaler_profile.value.new_pod_scale_up_delay
  #     scale_down_delay_after_add       = auto_scaler_profile.value.scale_down_delay_after_add
  #     scale_down_delay_after_delete    = auto_scaler_profile.value.scale_down_delay_after_delete
  #     scale_down_delay_after_failure   = auto_scaler_profile.value.scale_down_delay_after_failure
  #     scale_down_unneeded              = auto_scaler_profile.value.scale_down_unneeded
  #     scale_down_unready               = auto_scaler_profile.value.scale_down_unready
  #     scale_down_utilization_threshold = auto_scaler_profile.value.scale_down_utilization_threshold
  #     scan_interval                    = auto_scaler_profile.value.scan_interval
  #     skip_nodes_with_local_storage    = auto_scaler_profile.value.skip_nodes_with_local_storage
  #     skip_nodes_with_system_pods      = auto_scaler_profile.value.skip_nodes_with_system_pods
  #   }
  # }

  # dynamic "http_proxy_config" {
  #   for_each = var.settings.http_proxy_config != null ? [var.settings.http_proxy_config] : []
  #   content {
  #     http_proxy  = http_proxy_config.value.http_proxy
  #     https_proxy = http_proxy_config.value.https_proxy
  #     no_proxy    = http_proxy_config.value.no_proxy
  #     trusted_ca  = http_proxy_config.value.trusted_ca
  #   }
  # }

  # dynamic "ingress_application_gateway" {
  #   for_each = var.settings.ingress_application_gateway != null ? [var.settings.ingress_application_gateway] : []

  #   content {
  #     gateway_id   = ingress_application_gateway.value.gateway_id
  #     gateway_name = ingress_application_gateway.value.gateway_name
  #     subnet_cidr  = ingress_application_gateway.value.subnet_cidr
  #     subnet_id    = ingress_application_gateway.value.subnet_id
  #   }
  # }

  # dynamic "key_management_service" {
  #   for_each = var.settings.key_management_service != null ? [var.settings.key_management_service] : []

  #   content {
  #     key_vault_key_id         = key_management_service.value.key_vault_key_id
  #     key_vault_network_access = key_management_service.value.key_vault_network_access
  #   }

  # }

  # dynamic "kubelet_identity" {
  #   for_each = var.settings.kubelet_identity != null ? [var.settings.kubelet_identity] : []
  #   content {
  #     client_id                 = kubelet_identity.value.client_id
  #     object_id                 = kubelet_identity.value.object_id
  #     user_assigned_identity_id = kubelet_identity.value.user_assigned_identity_id
  #   }
  # }

  # dynamic "maintenance_window" {
  #   for_each = var.settings.maintenance_window != null ? [var.settings.maintenance_window] : []

  #   content {
  #     dynamic "allowed" {
  #       for_each = maintenance_window.value.allowed != null ? maintenance_window.value.allowed : []

  #       content {
  #         day   = allowed.value.day
  #         hours = allowed.value.hours
  #       }
  #     }
  #     dynamic "not_allowed" {
  #       for_each = maintenance_window.value.not_allowed != null ? maintenance_window.value.not_allowed : []

  #       content {
  #         end   = not_allowed.value.end
  #         start = not_allowed.value.start
  #       }
  #     }
  #   }
  # }

  dynamic "maintenance_window_auto_upgrade" {
    for_each = var.settings.maintenance_window_auto_upgrade != null ? [var.settings.maintenance_window_auto_upgrade] : []
    content {
      duration     = maintenance_window_auto_upgrade.value.duration
      frequency    = maintenance_window_auto_upgrade.value.frequency
      interval     = maintenance_window_auto_upgrade.value.interval
      day_of_month = maintenance_window_auto_upgrade.value.day_of_month
      day_of_week  = maintenance_window_auto_upgrade.value.day_of_week
      start_date   = maintenance_window_auto_upgrade.value.start_date
      start_time   = maintenance_window_auto_upgrade.value.start_time
      utc_offset   = maintenance_window_auto_upgrade.value.utc_offset
      week_index   = maintenance_window_auto_upgrade.value.week_index

      dynamic "not_allowed" {
        for_each = maintenance_window_auto_upgrade.value.not_allowed != null ? [maintenance_window_auto_upgrade.value.not_allowed] : []
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  dynamic "maintenance_window_node_os" {
    for_each = var.settings.maintenance_window_node_os != null ? [var.settings.maintenance_window_node_os] : []
    content {
      duration     = maintenance_window_node_os.value.duration
      frequency    = maintenance_window_node_os.value.frequency
      interval     = maintenance_window_node_os.value.interval
      day_of_month = maintenance_window_node_os.value.day_of_month
      day_of_week  = maintenance_window_node_os.value.day_of_week
      start_date   = maintenance_window_node_os.value.start_date
      start_time   = maintenance_window_node_os.value.start_time
      utc_offset   = maintenance_window_node_os.value.utc_offset
      week_index   = maintenance_window_node_os.value.week_index

      dynamic "not_allowed" {
        for_each = maintenance_window_node_os.value.not_allowed != null ? [maintenance_window_node_os.value.not_allowed] : []
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }
  # dynamic "microsoft_defender" {
  #   for_each = var.settings.microsoft_defender != null ? [var.settings.microsoft_defender] : []
  #   content {
  #     log_analytics_workspace_id = microsoft_defender.value.log_analytics_workspace_id
  #   }
  # }

  # dynamic "monitor_metrics" {
  #   for_each = var.settings.monitor_metrics != null ? [var.settings.monitor_metrics] : []

  #   content {
  #     annotations_allowed = monitor_metrics.value.annotations_allowed
  #     labels_allowed      = monitor_metrics.value.labels_allowed
  #   }
  # }

  dynamic "oms_agent" {
    for_each = var.settings.oms_agent != null ? [var.settings.oms_agent] : []

    content {
      log_analytics_workspace_id      = oms_agent.value.log_analytics_workspace_id
      msi_auth_for_monitoring_enabled = oms_agent.value.msi_auth_for_monitoring_enabled
    }
  }

  # dynamic "service_mesh_profile" {
  #   for_each = var.settings.service_mesh_profile == null ? [var.settings.service_mesh_profile] : []
  #   content {
  #     mode                             = var.service_mesh_profile.mode
  #     external_ingress_gateway_enabled = var.service_mesh_profile.external_ingress_gateway_enabled
  #     internal_ingress_gateway_enabled = var.service_mesh_profile.internal_ingress_gateway_enabled
  #   }
  # }


  # dynamic "web_app_routing" {
  #   for_each = var.settings.web_app_routing == null ? [var.settings.web_app_routing] : []

  #   content {
  #     dns_zone_id = var.web_app_routing.dns_zone_id
  #   }
  # }

  # dynamic "workload_autoscaler_profile" {
  #   for_each = var.settings.workload_autoscaler_profile == null ? [var.settings.workload_autoscaler_profile] : []

  #   content {
  #     keda_enabled                    = workload_autoscaler_profile.value.keda_enabled
  #     vertical_pod_autoscaler_enabled = workload_autoscaler_profile.value.vertical_pod_autoscaler_enabled
  #   }
  # }
  dynamic "network_profile" {
    for_each = var.settings.network_profile != null ? [var.settings.network_profile] : []
    content {
      network_plugin      = network_profile.value.network_plugin
      dns_service_ip      = network_profile.value.dns_service_ip
      ebpf_data_plane     = network_profile.value.ebpf_data_plane
      load_balancer_sku   = network_profile.value.load_balancer_sku
      network_plugin_mode = network_profile.value.network_plugin_mode
      network_policy      = network_profile.value.network_policy
      outbound_type       = network_profile.value.outbound_type
      pod_cidr            = network_profile.value.pod_cidr
      service_cidr        = network_profile.value.service_cidr


      dynamic "load_balancer_profile" {
        for_each = network_profile.value.load_balancer_profile != null ? [network_profile.value.load_balancer_profile != null] : []

        content {
          idle_timeout_in_minutes     = load_balancer_profile.value.idle_timeout_in_minutes
          managed_outbound_ip_count   = load_balancer_profile.value.managed_outbound_ip_count
          managed_outbound_ipv6_count = load_balancer_profile.value.managed_outbound_ipv6_count
          outbound_ip_address_ids     = load_balancer_profile.value.outbound_ip_address_ids
          outbound_ip_prefix_ids      = load_balancer_profile.value.outbound_ip_prefix_ids
          outbound_ports_allocated    = load_balancer_profile.value.outbound_ports_allocated
        }
      }
    }
  }



  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.settings.azure_active_directory_role_based_access_control != null ? [var.settings.azure_active_directory_role_based_access_control] : []
    content {
      managed                = azure_active_directory_role_based_access_control.value.managed
      admin_group_object_ids = azure_active_directory_role_based_access_control.value.admin_group_object_ids
      azure_rbac_enabled     = azure_active_directory_role_based_access_control.value.azure_rbac_enabled
      tenant_id              = azure_active_directory_role_based_access_control.value.tenant_id
    }
  }
 lifecycle {
    ignore_changes = [
      microsoft_defender
    ]
  }

}

resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = try({ for n in var.settings.kubernetes_cluster_node_pool : n.name => n }, {})

  kubernetes_cluster_id         = azurerm_kubernetes_cluster.this.id
  name                          = each.key
  vm_size                       = each.value.vm_size
  capacity_reservation_group_id = each.value.capacity_reservation_group_id
  custom_ca_trust_enabled       = each.value.custom_ca_trust_enabled
  enable_auto_scaling           = each.value.enable_auto_scaling
  enable_host_encryption        = each.value.enable_host_encryption
  enable_node_public_ip         = each.value.enable_node_public_ip
  eviction_policy               = each.value.eviction_policy
  fips_enabled                  = each.value.fips_enabled
  host_group_id                 = each.value.host_group_id
  kubelet_disk_type             = each.value.kubelet_disk_type
  max_count                     = each.value.max_count
  max_pods                      = each.value.max_pods
  message_of_the_day            = each.value.message_of_the_day
  min_count                     = each.value.min_count
  mode                          = each.value.mode
  node_count                    = each.value.node_count
  node_labels                   = each.value.node_labels
  node_public_ip_prefix_id      = each.value.node_public_ip_prefix_id
  node_taints                   = each.value.node_taints
  orchestrator_version          = each.value.orchestrator_version
  os_disk_size_gb               = each.value.os_disk_size_gb
  os_disk_type                  = each.value.os_disk_type
  os_sku                        = each.value.os_sku
  os_type                       = each.value.os_type
  pod_subnet_id                 = each.value.pod_subnet_id
  priority                      = each.value.priority
  proximity_placement_group_id  = each.value.proximity_placement_group_id
  scale_down_mode               = each.value.scale_down_mode
  snapshot_id                   = each.value.snapshot_id
  spot_max_price                = each.value.spot_max_price
  tags                          = var.settings.tags
  ultra_ssd_enabled             = each.value.ultra_ssd_enabled
  vnet_subnet_id                = each.value.vnet_subnet_id
  workload_runtime              = each.value.workload_runtime
  zones                         = each.value.zones

  dynamic "upgrade_settings" {
    for_each = each.value.upgrade_settings != null ? [each.value.upgrade_settings] : []

    content {
      max_surge                     = upgrade_settings.value.max_surge
      drain_timeout_in_minutes      = upgrade_settings.value.drain_timeout_in_minutes
      node_soak_duration_in_minutes = upgrade_settings.value.node_soak_duration_in_minutes

    }
  }

  dynamic "kubelet_config" {
    for_each = each.value.kubelet_config != null ? [each.value.kubelet_config] : []

    content {
      allowed_unsafe_sysctls    = kubelet_config.value.allowed_unsafe_sysctls
      container_log_max_line    = kubelet_config.value.container_log_max_files
      container_log_max_size_mb = kubelet_config.value.container_log_max_size_mb
      cpu_cfs_quota_enabled     = kubelet_config.value.cpu_cfs_quota_enabled
      cpu_cfs_quota_period      = kubelet_config.value.cpu_cfs_quota_period
      cpu_manager_policy        = kubelet_config.value.cpu_manager_policy
      image_gc_high_threshold   = kubelet_config.value.image_gc_high_threshold
      image_gc_low_threshold    = kubelet_config.value.image_gc_low_threshold
      pod_max_pid               = kubelet_config.value.pod_max_pid
      topology_manager_policy   = kubelet_config.value.topology_manager_policy
    }
  }
  dynamic "linux_os_config" {
    for_each = each.value.linux_os_config != null ? [each.value.linux_os_config] : []

    content {
      swap_file_size_mb             = linux_os_config.value.swap_file_size_mb
      transparent_huge_page_defrag  = linux_os_config.value.transparent_huge_page_defrag
      transparent_huge_page_enabled = linux_os_config.value.transparent_huge_page_enabled

      dynamic "sysctl_config" {
        for_each = linux_os_config.value.sysctl_config != null ? [linux_os_config.value.sysctl_config] : []

        content {
          fs_aio_max_nr                      = sysctl_config.value.fs_aio_max_nr
          fs_file_max                        = sysctl_config.value.fs_file_max
          fs_inotify_max_user_watches        = sysctl_config.value.fs_inotify_max_user_watches
          fs_nr_open                         = sysctl_config.value.fs_nr_open
          kernel_threads_max                 = sysctl_config.value.kernel_threads_max
          net_core_netdev_max_backlog        = sysctl_config.value.net_core_netdev_max_backlog
          net_core_optmem_max                = sysctl_config.value.net_core_optmem_max
          net_core_rmem_default              = sysctl_config.value.net_core_rmem_default
          net_core_rmem_max                  = sysctl_config.value.net_core_rmem_max
          net_core_somaxconn                 = sysctl_config.value.net_core_somaxconn
          net_core_wmem_default              = sysctl_config.value.net_core_wmem_default
          net_core_wmem_max                  = sysctl_config.value.net_core_wmem_max
          net_ipv4_ip_local_port_range_max   = sysctl_config.value.net_ipv4_ip_local_port_range_max
          net_ipv4_ip_local_port_range_min   = sysctl_config.value.net_ipv4_ip_local_port_range_min
          net_ipv4_neigh_default_gc_thresh1  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh1
          net_ipv4_neigh_default_gc_thresh2  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh2
          net_ipv4_neigh_default_gc_thresh3  = sysctl_config.value.net_ipv4_neigh_default_gc_thresh3
          net_ipv4_tcp_fin_timeout           = sysctl_config.value.net_ipv4_tcp_fin_timeout
          net_ipv4_tcp_keepalive_intvl       = sysctl_config.value.net_ipv4_tcp_keepalive_intvl
          net_ipv4_tcp_keepalive_probes      = sysctl_config.value.net_ipv4_tcp_keepalive_probes
          net_ipv4_tcp_keepalive_time        = sysctl_config.value.net_ipv4_tcp_keepalive_time
          net_ipv4_tcp_max_syn_backlog       = sysctl_config.value.net_ipv4_tcp_max_syn_backlog
          net_ipv4_tcp_max_tw_buckets        = sysctl_config.value.net_ipv4_tcp_max_tw_buckets
          net_ipv4_tcp_tw_reuse              = sysctl_config.value.net_ipv4_tcp_tw_reuse
          net_netfilter_nf_conntrack_buckets = sysctl_config.value.net_netfilter_nf_conntrack_buckets
          net_netfilter_nf_conntrack_max     = sysctl_config.value.net_netfilter_nf_conntrack_max
          vm_max_map_count                   = sysctl_config.value.vm_max_map_count
          vm_swappiness                      = sysctl_config.value.vm_swappiness
          vm_vfs_cache_pressure              = sysctl_config.value.vm_vfs_cache_pressure
        }
      }
    }
  }
  dynamic "node_network_profile" {
    for_each = each.value.node_network_profile != null ? [each.value.node_network_profile] : []

    content {
      node_public_ip_tags = node_network_profile.value.node_public_ip_tags
    }
  }
  dynamic "windows_profile" {
    for_each = each.value.windows_profile != null ? [each.value.windows_profile] : []

    content {
      outbound_nat_enabled = windows_profile.value.outbound_nat_enabled
    }
  }
}

resource "azurerm_role_assignment" "example" {
  principal_id = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope = var.settings.acrid
  skip_service_principal_aad_check = true
}
