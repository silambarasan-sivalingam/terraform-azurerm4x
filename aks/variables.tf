variable "settings" {
  description = "Settings for the Kubernetes cluster"
  type = object({
    name                                = string
    location                            = string
    resource_group_name                 = string
    automatic_channel_upgrade           = optional(string)
    azure_policy_enabled                = optional(bool)
    disk_encryption_set_id              = optional(string)
    dns_prefix                          = optional(string)
    dns_prefix_private_cluster          = optional(string)
    image_cleaner_enabled               = optional(bool)
    image_cleaner_interval_hours        = optional(number)
    kubernetes_version                  = optional(string)
    local_account_disabled              = optional(bool)
    node_os_channel_upgrade             = optional(string)
    node_resource_group                 = optional(string)
    oidc_issuer_enabled                 = optional(bool)
    open_service_mesh_enabled           = optional(bool)
    private_cluster_enabled             = optional(bool)
    private_cluster_public_fqdn_enabled = optional(bool)
    private_dns_zone_id                 = optional(string)
    acrid                               = optional(string)
    role_based_access_control_enabled   = optional(bool)
    run_command_enabled                 = optional(bool)
    sku_tier                            = optional(string)
    support_plan                        = optional(string)
    tags                                = optional(map(string))
    workload_identity_enabled           = optional(bool)
    custom_ca_trust_certificates_base64 = optional(list(string))
    edge_zone                           = optional(string)
    http_application_routing_enabled    = optional(bool)

    confidential_computing = optional(object({
      sgx_quote_helper_enabled = any
    }))

    default_node_pool = object({
      name                         = string
      vm_size                      = optional(string)
      enable_auto_scaling          = optional(bool)
      enable_host_encryption       = optional(bool)
      enable_node_public_ip        = optional(bool)
      fips_enabled                 = optional(bool)
      node_count                   = number
      max_count                    = optional(number)
      max_pods                     = optional(number)
      min_count                    = optional(number)
      node_labels                  = optional(map(string))
      only_critical_addons_enabled = optional(bool)
      orchestrator_version         = optional(string)
      os_disk_size_gb              = optional(number)
      os_disk_type                 = optional(string)
      os_sku                       = optional(string)
      pod_subnet_id                = optional(string)
      proximity_placement_group_id = optional(string)
      scale_down_mode              = optional(string)
      snapshot_id                  = optional(string)
      tags                         = optional(map(string))
      temporary_name_for_rotation  = optional(string)
      type                         = optional(string)
      ultra_ssd_enabled            = optional(bool)
      vnet_subnet_id               = optional(string)
      zones                        = optional(list(string))

      upgrade_settings = optional(object({
        max_surge                     = any
        drain_timeout_in_minutes      = any
        node_soak_duration_in_minutes = any
      }))

      kubelet_config = optional(object({
        allowed_unsafe_sysctls    = optional(list(string))
        container_log_max_line    = optional(number)
        container_log_max_size_mb = optional(number)
        cpu_cfs_quota_enabled     = optional(bool)
        cpu_cfs_quota_period      = optional(string)
        cpu_manager_policy        = optional(string)
        image_gc_high_threshold   = optional(number)
        image_gc_low_threshold    = optional(number)
        pod_max_pid               = optional(number)
        topology_manager_policy   = optional(string)
      }))

      linux_os_config = optional(object({
        swap_file_size_mb             = optional(number)
        transparent_huge_page_defrag  = optional(string)
        transparent_huge_page_enabled = optional(string)

        sysctl_configs = optional(object({
          fs_aio_max_nr                                      = optional(number)
          fs_file_max                                        = optional(number)
          fs_inotify_max_user_watches                        = optional(number)
          fs_nr_open                                         = optional(number)
          kernel_threads_max                                 = optional(number)
          net_core_netdev_max_backlog                        = optional(number)
          net_core_optmem_max                                = optional(number)
          net_core_rmem_default                              = optional(number)
          net_core_rmem_max                                  = optional(number)
          net_core_somaxconn                                 = optional(number)
          net_core_wmem_default                              = optional(number)
          net_core_wmem_max                                  = optional(number)
          net_ipv4_ip_local_port_range_max                   = optional(number)
          net_ipv4_ip_local_port_range_min                   = optional(number)
          net_ipv4_neigh_default_gc_thresh1                  = optional(number)
          net_ipv4_neigh_default_gc_thresh2                  = optional(number)
          net_ipv4_neigh_default_gc_thresh3                  = optional(number)
          net_ipv4_tcp_fin_timeout                           = optional(number)
          net_ipv4_tcp_keepalive_intvl                       = optional(number)
          net_ipv4_tcp_keepalive_probes                      = optional(number)
          net_ipv4_tcp_keepalive_time                        = optional(number)
          net_ipv4_tcp_max_syn_backlog                       = optional(number)
          net_ipv4_tcp_max_tw_buckets                        = optional(number)
          net_ipv4_tcp_rmem                                  = optional(list(number))
          net_ipv4_tcp_syn_retries                           = optional(number)
          net_ipv4_tcp_tw_reuse                              = optional(bool)
          net_ipv4_tcp_wmem                                  = optional(list(number))
          net_netfilter_nf_conntrack_max                     = optional(number)
          net_netfilter_nf_conntrack_tcp_timeout_established = optional(number)
          net_sctp_path_max_retrans                          = optional(number)
          vm_max_map_count                                   = optional(number)
          vm_swappiness                                      = optional(number)
          vm_vfs_cache_pressure                              = optional(number)
        }))


      }))
    })

    key_vault_secrets_provider = optional(object({
      secret_rotation_enabled  = optional(bool)
      secret_rotation_interval = optional(string)
    }))

    identity = optional(object({
      type         = string
      identity_ids = list(string)
    }))

    service_principal = optional(object({
      client_id     = string
      client_secret = string
    }))

    ssh_key = optional(object({
      key_data = string
    }))

    storage_profile = optional(object({
      blob_driver_enabled         = optional(bool)
      disk_driver_enabled         = optional(bool)
      disk_driver_version         = optional(string)
      file_driver_enabled         = optional(bool)
      snapshot_controller_enabled = optional(bool)
    }))

    aci_connector_linux = optional(object({
      subnet_name = optional(string)
    }))

    api_server_access_profile = optional(object({
      authorized_ip_ranges     = optional(list(string))
      subnet_id                = optional(string)
      vnet_integration_enabled = optional(bool)
    }))

    auto_scaler_profile = optional(object({
      balance_similar_node_groups      = optional(bool)
      empty_bulk_delete_max            = optional(number)
      expander                         = optional(string)
      max_graceful_termination_sec     = optional(number)
      max_node_provisioning_time       = optional(string)
      max_unready_nodes                = optional(number)
      max_unready_percentage           = optional(number)
      new_pod_scale_up_delay           = optional(string)
      scale_down_delay_after_add       = optional(string)
      scale_down_delay_after_delete    = optional(string)
      scale_down_delay_after_failure   = optional(string)
      scale_down_unneeded              = optional(string)
      scale_down_unready               = optional(string)
      scale_down_utilization_threshold = optional(number)
      scan_interval                    = optional(string)
      skip_nodes_with_local_storage    = optional(bool)
      skip_nodes_with_system_pods      = optional(bool)
    }))

    http_proxy_config = optional(object({
      http_proxy  = optional(string)
      https_proxy = optional(string)
      no_proxy    = optional(list(string))
      trusted_ca  = optional(string)
    }))

    ingress_application_gateway = optional(object({
      gateway_id   = optional(string)
      gateway_name = optional(string)
      subnet_cidr  = optional(string)
      subnet_id    = optional(string)
    }))

    key_management_service = optional(object({
      key_vault_key_id         = optional(string)
      key_vault_network_access = optional(string)
    }))

    kubelet_identity = optional(object({
      client_id                 = optional(string)
      object_id                 = optional(string)
      user_assigned_identity_id = optional(string)
    }))

    maintenance_window = optional(object({
      allowed = optional(list(object({
        day   = string
        hours = list(string)
      })))

      not_allowed = optional(list(object({
        end   = string
        start = string
      })))
    }))

    maintenance_window_auto_upgrade = optional(object({
      duration     = optional(string)
      frequency    = optional(string)
      interval     = optional(string)
      day_of_month = optional(string)
      day_of_week  = optional(string)
      start_date   = optional(string)
      start_time   = optional(string)
      utc_offset   = optional(string)
      week_index   = optional(string)
      not_allowed = optional(list(object({
        end   = optional(string)
        start = optional(string)
      })))
    }))

    maintenance_window_node_os = optional(object({
      duration     = optional(string)
      frequency    = optional(string)
      interval     = optional(string)
      day_of_month = optional(string)
      day_of_week  = optional(string)
      start_date   = optional(string)
      start_time   = optional(string)
      utc_offset   = optional(string)
      week_index   = optional(string)
      not_allowed = optional(list(object({
        end   = optional(string)
        start = optional(string)
      })))
    }))

    microsoft_defender = optional(object({
      log_analytics_workspace_id = optional(string)
    }))

    monitor_metrics = optional(object({
      annotations_allowed = optional(bool)
      labels_allowed      = optional(bool)
    }))

    oms_agent = optional(object({
      log_analytics_workspace_id      = optional(string)
      msi_auth_for_monitoring_enabled = optional(bool)
    }))

    service_mesh_profile = optional(object({
      mode                             = optional(string)
      external_ingress_gateway_enabled = optional(bool)
      internal_ingress_gateway_enabled = optional(bool)
    }))

    web_app_routing = optional(object({
      dns_zone_id = optional(string)
    }))

    workload_autoscaler_profile = optional(object({
      keda_enabled                    = optional(bool)
      vertical_pod_autoscaler_enabled = optional(bool)
    }))

    azure_active_directory_role_based_access_control = optional(object({
      admin_group_object_ids = optional(list(string))
      azure_rbac_enabled     = optional(bool)
      tenant_id              = optional(string)
      managed                = optional(bool)
    }))

    network_profile = optional(object({
      network_plugin      = optional(string)
      dns_service_ip      = optional(string)
      ebpf_data_plane     = optional(bool)
      load_balancer_sku   = optional(string)
      network_plugin_mode = optional(string)
      network_policy      = optional(string)
      outbound_type       = optional(string)
      pod_cidr            = optional(string)
      service_cidr        = optional(string)
      load_balancer_profile = optional(object({
        idle_timeout_in_minutes     = optional(number)
        managed_outbound_ip_count   = optional(number)
        managed_outbound_ipv6_count = optional(number)
        outbound_ip_address_ids     = optional(list(string))
        outbound_ip_prefix_ids      = optional(list(string))
        outbound_ports_allocated    = optional(number)
      }))
    }))



    log_analytics_workspace_id = optional(string)


    kubernetes_cluster_node_pool = list(object({
      name                          = string
      vm_size                       = string
      capacity_reservation_group_id = optional(string)
      custom_ca_trust_enabled       = optional(bool)
      enable_auto_scaling           = optional(bool)
      enable_host_encryption        = optional(bool)
      enable_node_public_ip         = optional(bool)
      eviction_policy               = optional(string)
      fips_enabled                  = optional(bool)
      host_group_id                 = optional(string)
      kubelet_disk_type             = optional(string)
      max_count                     = optional(number)
      max_pods                      = optional(number)
      message_of_the_day            = optional(string)
      min_count                     = optional(number)
      mode                          = optional(string)
      node_count                    = optional(number)
      node_labels                   = optional(map(string))
      node_public_ip_prefix_id      = optional(string)
      node_taints                   = optional(list(string))
      orchestrator_version          = optional(string)
      os_disk_size_gb               = optional(number)
      os_disk_type                  = optional(string)
      os_sku                        = optional(string)
      os_type                       = optional(string)
      pod_subnet_id                 = optional(string)
      priority                      = optional(string)
      proximity_placement_group_id  = optional(string)
      scale_down_mode               = optional(string)
      snapshot_id                   = optional(string)
      spot_max_price                = optional(number)
      tags                          = optional(map(string))
      ultra_ssd_enabled             = optional(bool)
      vnet_subnet_id                = optional(string)
      workload_runtime              = optional(string)
      zones                         = optional(list(string))

      upgrade_settings = optional(object({
        max_surge                     = any
        drain_timeout_in_minutes      = any
        node_soak_duration_in_minutes = any
      }))

      kubelet_config = optional(object({
        allowed_unsafe_sysctls    = optional(list(string))
        container_log_max_line    = optional(number)
        container_log_max_size_mb = optional(number)
        cpu_cfs_quota_enabled     = optional(bool)
        cpu_cfs_quota_period      = optional(string)
        cpu_manager_policy        = optional(string)
        image_gc_high_threshold   = optional(number)
        image_gc_low_threshold    = optional(number)
        pod_max_pid               = optional(number)
        topology_manager_policy   = optional(string)
      }))

      linux_os_config = optional(object({
        swap_file_size_mb             = optional(number)
        transparent_huge_page_defrag  = optional(string)
        transparent_huge_page_enabled = optional(string)
        sysctl_config = optional(object({
          fs_aio_max_nr                      = optional(number)
          fs_file_max                        = optional(number)
          fs_inotify_max_user_watches        = optional(number)
          fs_nr_open                         = optional(number)
          kernel_threads_max                 = optional(number)
          net_core_netdev_max_backlog        = optional(number)
          net_core_optmem_max                = optional(number)
          net_core_rmem_default              = optional(number)
          net_core_rmem_max                  = optional(number)
          net_core_somaxconn                 = optional(number)
          net_core_wmem_default              = optional(number)
          net_core_wmem_max                  = optional(number)
          net_ipv4_ip_local_port_range_max   = optional(number)
          net_ipv4_ip_local_port_range_min   = optional(number)
          net_ipv4_neigh_default_gc_thresh1  = optional(number)
          net_ipv4_neigh_default_gc_thresh2  = optional(number)
          net_ipv4_neigh_default_gc_thresh3  = optional(number)
          net_ipv4_tcp_fin_timeout           = optional(number)
          net_ipv4_tcp_keepalive_intvl       = optional(number)
          net_ipv4_tcp_keepalive_probes      = optional(number)
          net_ipv4_tcp_keepalive_time        = optional(number)
          net_ipv4_tcp_max_syn_backlog       = optional(number)
          net_ipv4_tcp_max_tw_buckets        = optional(number)
          net_ipv4_tcp_tw_reuse              = optional(bool)
          net_netfilter_nf_conntrack_buckets = optional(number)
          net_netfilter_nf_conntrack_max     = optional(number)
          vm_max_map_count                   = optional(number)
          vm_swappiness                      = optional(number)
          vm_vfs_cache_pressure              = optional(number)
        }))
      }))

      node_network_profile = optional(object({
        node_public_ip_tags = optional(map(string))
      }))

      windows_profile = optional(object({
        outbound_nat_enabled = optional(bool)
      }))
    }))
  })
}
