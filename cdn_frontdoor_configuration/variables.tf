variable "settings" {
  description = "Front Door configuration."
  type = object({

    cdn_frontdoor_profile_id = string

    secret = optional(object({
      enabled           = bool
      name              = string
      kv_certificate_id = string
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
        certificate_type        = optional(string, "ManagedCertificate")
        minimum_tls_version     = optional(string, "TLS12")
        cdn_frontdoor_secret_id = optional(string)
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
      cdn_frontdoor_rule_set_ids    = optional(list(string))
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
  })
}
