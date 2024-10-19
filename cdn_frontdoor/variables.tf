variable "settings" {
  description = "Front Door configuration."
  type = object({
    dns_id = optional(string)

    profile = object({
      name                     = string
      resource_group_name      = string
      sku_name                 = string
      response_timeout_seconds = optional(string, 120)
      tags                     = optional(map(string), null)

      identity = optional(object({
        type         = string
        identity_ids = list(string)
      }))


    })

    azurerm_role_assignment = optional(list(object({
      name                 = string
      scope                = string
      role_definition_name = string
    })))


    azurerm_cdn_frontdoor_security_policy = optional(object({
      cdn_frontdoor_domain_id = string
    }))

    secret = optional(object({
      enabled           = bool
      name              = string
      kv_certificate_id = string
    }))

    custom_domain = optional(object({
      name      = string
      host_name = string
      tls = object({
        certificate_type    = string
        minimum_tls_version = string
      })
    }))

    endpoint = optional(object({
      name      = string
      enabled   = bool
      routename = optional(string)
    }))

    endpoints = optional(list(object({
      name      = string
      enabled   = bool
      routename = optional(string)
    })))

    origin_groups = optional(list(object({
      name                                                      = string
      session_affinity_enabled                                  = optional(bool, false)
      restore_traffic_time_to_healed_or_new_endpoint_in_minutes = optional(number, 0)
      health_probe = optional(object({
        interval_in_seconds = number
        path                = string
        protocol            = string
        request_type        = string
      }))
      load_balancing = object({
        additional_latency_in_milliseconds = number
        sample_size                        = number
        successful_samples_required        = number
      })
    })))

    origins = optional(list(object({
      name                           = string
      origin_group_name              = string
      enabled                        = bool
      certificate_name_check_enabled = bool
      host_name                      = string
      http_port                      = number
      https_port                     = number
      origin_host_header             = string
      priority                       = number
      weight                         = number

      private_link = optional(object({
        request_message        = string
        target_type            = optional(string)
        location               = string
        private_link_target_id = string
      }))
    })))

    rule_sets = optional(list(object({
      name = string
    })))

    frontdoor_secrets = optional(list(object({
      name                      = string
      key_vault_certificate_id  = string
      subject_alternative_names = optional(list(string))
    })))

    custom_domains = optional(list(object({
      name        = string
      dns_zone_id = optional(string)
      host_name   = string

      tls = object({
        certificate_type      = optional(string, "ManagedCertificate")
        minimum_tls_version   = optional(string, "TLS12")
        frontdoor_secret_name = optional(string)
      })
    })))

    frontdoor_rules = optional(list(object({
      name              = string
      rule_set_name     = string
      order             = number
      behavior_on_match = optional(string)

      actions = optional(list(object({
        route_configuration_override_action = optional(list(object({
          frontdoor_origin_group_name   = string
          forwarding_protocol           = string
          query_string_caching_behavior = string
          query_string_parameters       = list(string)
          compression_enabled           = optional(bool, true)
          cache_behavior                = string
          cache_duration                = string
        })))
        url_redirect_action = optional(list(object({
          redirect_type        = string
          redirect_protocol    = string
          query_string         = string
          destination_path     = string
          destination_hostname = string
          destination_fragment = string
        })))

        url_rewrite_action = optional(list(object({
          destination             = string
          preserve_unmatched_path = bool
          source_pattern          = string
        })))

        response_header_action = optional(list(object({
          header_action = string
          header_name   = string
          value         = string
        })))

      })))

      conditions = optional(list(object({
        host_name_condition = optional(list(object({
          operator         = string
          negate_condition = bool
          match_values     = list(string)
          transforms       = list(string)
        })))
        is_device_condition = optional(list(object({
          operator         = string
          negate_condition = bool
          match_values     = list(string)
        })))
        post_args_condition = optional(list(object({
          post_args_name = string
          operator       = string
          match_values   = list(string)
          transforms     = list(string)
        })))
        request_method_condition = optional(list(object({
          operator         = string
          negate_condition = bool
          match_values     = list(string)
        })))
        request_scheme_condition = optional(list(object({
          match_values     = list(string)
          negate_condition = bool
          operator         = string
        })))

        request_header_condition = optional(list(object({
          header_name      = string
          match_values     = list(string)
          negate_condition = bool
          operator         = string
          transforms       = list(string)
        })))

        request_uri_condition = optional(list(object({
          match_values     = list(string)
          negate_condition = bool
          operator         = string
          transforms       = list(string)
        })))
        url_filename_condition = optional(list(object({
          operator         = string
          negate_condition = bool
          match_values     = list(string)
          transforms       = list(string)
        })))
      })))
    })))

    routes = optional(list(object({
      name                          = string
      frontdoor_endpoint_name       = string
      frontdoor_origin_group_name   = string
      frontdoor_origin_names        = optional(list(string))
      frontdoor_rule_set_names      = optional(list(string))
      frontdoor_origin_path         = optional(string)
      enabled                       = bool
      forwarding_protocol           = string
      https_redirect_enabled        = optional(bool, false)
      patterns_to_match             = list(string)
      supported_protocols           = list(string)
      frontdoor_custom_domain_names = optional(list(string))
      link_to_default_domain        = optional(bool, true)

      cache = optional(object({
        query_string_caching_behavior = string
        query_strings                 = list(string)
        compression_enabled           = optional(bool, true)
        content_types_to_compress     = list(string)
      }))

    })))




    cdn_frontdoor_firewall_policy = optional(list(object({
      name                              = string
      resource_group_name               = string
      location                          = string
      enabled                           = optional(bool, true)
      mode                              = string
      redirect_url                      = optional(string)
      custom_block_response_status_code = optional(number)
      custom_block_response_body        = optional(string)
      custom_rule = optional(list(object({
        name     = string
        action   = string
        enabled  = optional(bool)
        priority = optional(number)
        type     = string
        match_condition = list(object({
          match_variable     = string
          match_values       = list(string)
          operator           = string
          selector           = optional(string)
          negation_condition = optional(string)
          transforms         = optional(list(string))
        }))
        rate_limit_duration_in_minutes = optional(number, 1)
        rate_limit_threshold           = optional(number, 10)
      })))
      managed_rule = optional(list(object({
        type    = optional(string)
        version = string
        action  = string
        exclusion = optional(list(object({
          match_variable = string
          operator       = string
          selector       = string
        })))
        override = optional(list(object({
          rule_group_name = string
          override_exclusion = optional(list(object({
            match_variable = string
            operator       = string
            selector       = string
          })))
          rule = optional(list(object({
            rule_id = string
            action  = string
            enabled = optional(bool, false)
            override_rule_exclusion = optional(list(object({
              match_variable = string
              operator       = string
              selector       = string
            })))
          })))
        })))
      })))
    })))

    cdn_frontdoor_security_policy = optional(list(object({
      name = string

      security_policies = optional(object({
        firewall = object({
          cdn_frontdoor_firewall_policy_name = string
          association = object({
            domain = object({
              cdn_frontdoor_domain_name = string
            })
            patterns_to_match = list(string)
          })
        })
      }))

    })))



    tags = optional(map(string), null)
  })
}
