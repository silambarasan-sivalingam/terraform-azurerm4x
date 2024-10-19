resource "azurerm_cdn_frontdoor_profile" "this" {
  name                     = var.settings.profile.name
  resource_group_name      = var.settings.profile.resource_group_name
  sku_name                 = var.settings.profile.sku_name
  response_timeout_seconds = var.settings.profile.response_timeout_seconds
  tags                     = var.settings.tags
}


resource "azurerm_cdn_frontdoor_endpoint" "this" {
  for_each                 = try({ for n in var.settings.endpoints : n.name => n }, {})
  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  enabled                  = each.value.enabled
}


resource "azurerm_cdn_frontdoor_origin_group" "this" {
  for_each                 = try({ for n in var.settings.origin_groups : n.name => n }, {})
  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  session_affinity_enabled = each.value.session_affinity_enabled

  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = each.value.restore_traffic_time_to_healed_or_new_endpoint_in_minutes

  dynamic "health_probe" {
    for_each = each.value.health_probe != null ? { enabled = true } : {}

    content {
      interval_in_seconds = each.value.health_probe.interval_in_seconds
      path                = each.value.health_probe.path
      protocol            = each.value.health_probe.protocol
      request_type        = each.value.health_probe.request_type
    }
  }

  load_balancing {
    additional_latency_in_milliseconds = each.value.load_balancing.additional_latency_in_milliseconds
    sample_size                        = each.value.load_balancing.sample_size
    successful_samples_required        = each.value.load_balancing.successful_samples_required
  }
}

resource "azurerm_cdn_frontdoor_rule_set" "this" {
  for_each                 = try({ for n in var.settings.rule_sets : n.name => n }, {})
  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
}

resource "azurerm_cdn_frontdoor_origin" "this" {
  for_each                      = try({ for n in var.settings.origins : n.name => n }, {})
  name                          = each.key
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this[each.value.origin_group_name].id
  enabled                       = each.value.enabled

  certificate_name_check_enabled = each.value.certificate_name_check_enabled

  host_name          = each.value.host_name
  http_port          = each.value.http_port
  https_port         = each.value.https_port
  origin_host_header = each.value.origin_host_header
  priority           = each.value.priority
  weight             = each.value.weight

  dynamic "private_link" {
    for_each = each.value.private_link != null ? { enabled = true } : {}
    content {
      request_message        = each.value.private_link.request_message
      target_type            = each.value.private_link.target_type
      location               = each.value.private_link.location
      private_link_target_id = each.value.private_link.private_link_target_id
    }
  }
  depends_on = [azurerm_cdn_frontdoor_origin_group.this]
}


resource "azurerm_cdn_frontdoor_secret" "this" {
  for_each                 = try({ for n in var.settings.frontdoor_secrets : n.name => n }, {})
  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id

  secret {
    customer_certificate {
      key_vault_certificate_id  = each.value.key_vault_certificate_id
      subject_alternative_names = each.value.subject_alternative_names
    }
  }
}

resource "azurerm_cdn_frontdoor_custom_domain" "this" {
  for_each                 = try({ for n in var.settings.custom_domains : n.name => n }, {})
  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  dns_zone_id              = each.value.dns_zone_id
  host_name                = each.value.host_name

  tls {
    certificate_type        = each.value.tls.certificate_type
    minimum_tls_version     = each.value.tls.minimum_tls_version
    cdn_frontdoor_secret_id = each.value.tls.frontdoor_secret_name != null ? azurerm_cdn_frontdoor_secret.this[each.value.tls.frontdoor_secret_name].id : null
  }
}

resource "azurerm_cdn_frontdoor_route" "this" {
  for_each                      = try({ for n in var.settings.routes : n.name => n }, {})
  name                          = each.key
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.this[each.value.frontdoor_endpoint_name].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this[each.value.frontdoor_origin_group_name].id
  cdn_frontdoor_origin_path     = each.value.frontdoor_origin_path

  cdn_frontdoor_origin_ids = each.value.frontdoor_origin_names != null ? [
    for origin_name in each.value.frontdoor_origin_names :
    azurerm_cdn_frontdoor_origin.this[origin_name].id
  ] : []

  cdn_frontdoor_rule_set_ids = each.value.frontdoor_rule_set_names != null ? [
    for rule_set_name in each.value.frontdoor_rule_set_names :
    azurerm_cdn_frontdoor_rule_set.this[rule_set_name].id
  ] : []

  enabled                = each.value.enabled
  forwarding_protocol    = each.value.forwarding_protocol
  https_redirect_enabled = each.value.https_redirect_enabled
  patterns_to_match      = each.value.patterns_to_match
  supported_protocols    = each.value.supported_protocols

  cdn_frontdoor_custom_domain_ids = each.value.frontdoor_custom_domain_names != null ? [
    for custom_domain_name in each.value.frontdoor_custom_domain_names :
    azurerm_cdn_frontdoor_custom_domain.this[custom_domain_name].id
  ] : []

  link_to_default_domain = each.value.link_to_default_domain

  dynamic "cache" {
    for_each = each.value.cache != null ? { enabled = true } : {}
    content {
      query_string_caching_behavior = each.value.cache.query_string_caching_behavior
      query_strings                 = each.value.cache.query_strings
      compression_enabled           = each.value.cache.compression_enabled
      content_types_to_compress     = each.value.cache.content_types_to_compress
    }
  }
}

resource "azurerm_cdn_frontdoor_rule" "this" {

  for_each                  = try({ for n in var.settings.frontdoor_rules : n.name => n }, {})
  name                      = each.key
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.this[each.value.rule_set_name].id
  order                     = each.value.order
  behavior_on_match         = each.value.behavior_on_match

  dynamic "actions" {
    for_each = each.value.actions != null ? each.value.actions : []
    # for_each =  (each.value.custom_rule == null) ? [] : each.value.custom_rule
    content {
      dynamic "route_configuration_override_action" {
        for_each = actions.value.route_configuration_override_action != null ? actions.value.route_configuration_override_action : []
        content {
          cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this[route_configuration_override_action.value.frontdoor_origin_group_name].id
          forwarding_protocol           = route_configuration_override_action.value.forwarding_protocol
          query_string_caching_behavior = route_configuration_override_action.value.query_string_caching_behavior
          query_string_parameters       = route_configuration_override_action.value.query_string_parameters
          compression_enabled           = route_configuration_override_action.value.compression_enabled
          cache_behavior                = route_configuration_override_action.value.cache_behavior
          cache_duration                = route_configuration_override_action.value.cache_duration
        }
      }

      dynamic "url_redirect_action" {
        for_each = actions.value.url_redirect_action != null ? actions.value.url_redirect_action : []
        content {
          redirect_type        = url_redirect_action.value.redirect_type
          redirect_protocol    = url_redirect_action.value.redirect_protocol
          query_string         = url_redirect_action.value.query_string
          destination_path     = url_redirect_action.value.destination_path
          destination_hostname = url_redirect_action.value.destination_hostname
          destination_fragment = url_redirect_action.value.destination_fragment
        }
      }

      dynamic "url_rewrite_action" {
        for_each = actions.value.url_rewrite_action != null ? actions.value.url_rewrite_action : []
        content {
          destination             = url_rewrite_action.value.destination
          preserve_unmatched_path = url_rewrite_action.value.preserve_unmatched_path
          source_pattern          = url_rewrite_action.value.source_pattern
        }
      }

      dynamic "response_header_action" {
        for_each = actions.value.response_header_action != null ? actions.value.response_header_action : []
        content {
          header_action = response_header_action.value.header_action
          header_name   = response_header_action.value.header_name
          value         = response_header_action.value.value
        }
      }
    }
  }

  dynamic "conditions" {
    for_each = each.value.conditions != null ? each.value.conditions : []

    content {
      dynamic "host_name_condition" {
        for_each = conditions.value.host_name_condition != null ? conditions.value.host_name_condition : []
        content {
          operator         = host_name_condition.value.operator
          negate_condition = host_name_condition.value.negate_condition
          match_values     = host_name_condition.value.match_values
          transforms       = host_name_condition.value.transforms
        }

      }

      dynamic "is_device_condition" {
        for_each = conditions.value.is_device_condition != null ? conditions.value.is_device_condition : []
        content {
          operator         = is_device_condition.value.operator
          negate_condition = is_device_condition.value.negate_condition
          match_values     = is_device_condition.value.match_values
        }
      }

      dynamic "post_args_condition" {

        for_each = conditions.value.post_args_condition != null ? conditions.value.post_args_condition : []

        content {
          post_args_name = post_args_condition.value.post_args_name
          operator       = post_args_condition.value.operator
          match_values   = post_args_condition.value.match_values
          transforms     = post_args_condition.value.transforms
        }

      }

      dynamic "request_method_condition" {
        for_each = conditions.value.request_method_condition != null ? conditions.value.request_method_condition : []

        content {
          operator         = request_method_condition.value.operator
          negate_condition = request_method_condition.value.negate_condition
          match_values     = request_method_condition.value.match_values
        }

      }

      dynamic "request_scheme_condition" {
        for_each = conditions.value.request_scheme_condition != null ? conditions.value.request_scheme_condition : []

        content {
          match_values     = request_scheme_condition.value.match_values
          negate_condition = request_scheme_condition.value.negate_condition
          operator         = request_scheme_condition.value.operator
        }

      }


      dynamic "request_header_condition" {
        for_each = conditions.value.request_header_condition != null ? conditions.value.request_header_condition : []

        content {
          header_name      = request_header_condition.value.header_name
          match_values     = request_header_condition.value.match_values
          negate_condition = request_header_condition.value.negate_condition
          operator         = request_header_condition.value.operator
          transforms       = request_header_condition.value.transforms
        }

      }

      dynamic "request_uri_condition" {
        for_each = conditions.value.request_uri_condition != null ? conditions.value.request_uri_condition : []

        content {
          match_values     = request_uri_condition.value.match_values
          negate_condition = request_uri_condition.value.negate_condition
          operator         = request_uri_condition.value.operator
          transforms       = request_uri_condition.value.transforms
        }

      }

      dynamic "url_filename_condition" {
        for_each = conditions.value.url_filename_condition != null ? conditions.value.url_filename_condition : []

        content {
          operator         = url_filename_condition.value.operator
          negate_condition = url_filename_condition.value.negate_condition
          match_values     = url_filename_condition.value.match_values
          transforms       = url_filename_condition.value.transforms
        }
      }
    }

  }
}



resource "azurerm_cdn_frontdoor_firewall_policy" "this" {
  for_each = try({ for n in var.settings.cdn_frontdoor_firewall_policy : n.name => n }, {})

  name                              = each.key
  resource_group_name               = var.settings.resource_group_name
  sku_name                          = azurerm_cdn_frontdoor_profile.this.sku_name
  enabled                           = each.value.enabled
  mode                              = each.value.mode
  redirect_url                      = each.value.redirect_url
  custom_block_response_status_code = each.value.custom_block_response_status_code
  custom_block_response_body        = each.value.custom_block_response_body

  dynamic "custom_rule" {
    for_each = each.value.custom_rule != null ? each.value.custom_rule : []

    content {
      name     = custom_rule.value.name
      action   = custom_rule.value.action
      enabled  = custom_rule.value.enabled
      priority = custom_rule.value.priority
      type     = custom_rule.value.type

      dynamic "match_condition" {
        for_each = (custom_rule.value.match_condition == null) ? [] : custom_rule.value.match_condition
        content {
          match_variable     = match_condition.value.match_variable
          match_values       = match_condition.value.match_values
          operator           = match_condition.value.operator
          selector           = match_condition.value.selector
          negation_condition = match_condition.value.negation_condition
          transforms         = match_condition.value.transforms
        }
      }
      rate_limit_duration_in_minutes = custom_rule.value.rate_limit_duration_in_minutes
      rate_limit_threshold           = custom_rule.value.rate_limit_duration_in_minutes
    }
  }

  dynamic "managed_rule" {
    for_each = (each.value.managed_rule == null) ? [] : each.value.managed_rule

    content {
      version = managed_rule.value.version
      type    = managed_rule.value.type
      action  = managed_rule.value.action

      dynamic "exclusion" {
        for_each = (managed_rule.value.exclusion == null) ? [] : managed_rule.value.exclusion
        content {
          match_variable = exclusion.value.match_variable
          operator       = exclusion.value.operator
          selector       = exclusion.value.selector
        }
      }

      dynamic "override" {
        for_each = (managed_rule.value.override == null) ? [] : managed_rule.value.override

        content {
          rule_group_name = override.value.rule_group_name

          dynamic "exclusion" {
            for_each = (override.value.override_exclusion == null) ? [] : override.value.override_exclusion

            content {
              match_variable = exclusion.value.match_variable
              operator       = exclusion.value.operator
              selector       = exclusion.value.selector
            }
          }

          dynamic "rule" {
            for_each = (override.value.rule == null) ? [] : override.value.rule

            content {
              rule_id = rule.value.rule_id
              action  = rule.value.action
              enabled = rule.value.enabled

              dynamic "exclusion" {
                for_each = (rule.value.override_rule_exclusion == null) ? [] : rule.value.override_rule_exclusion

                content {
                  match_variable = exclusion.value.match_variable
                  operator       = exclusion.value.operator
                  selector       = exclusion.value.selector
                }
              }
            }
          }
        }
      }

    }
  }

  lifecycle {
    ignore_changes = [managed_rule]
  }
  tags = var.settings.tags
}

resource "azurerm_cdn_frontdoor_security_policy" "this" {
  for_each                 = try({ for n in var.settings.cdn_frontdoor_security_policy : n.name => n }, {})
  name                     = each.key
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id

  dynamic "security_policies" {
    for_each = each.value.security_policies != null ? [each.value.security_policies] : []

    content {

      dynamic "firewall" {
        for_each = security_policies.value.firewall != null ? [security_policies.value.firewall] : []

        content {
          cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.this[firewall.value.cdn_frontdoor_firewall_policy_name].id

          dynamic "association" {
            for_each = security_policies.value.association != null ? [security_policies.value.association] : []
            content {
              dynamic "domain" {
                for_each = association.value.domain != null ? association.value.domain : []
                content {
                  cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_custom_domain.this[domain.value.cdn_frontdoor_domain_name].id
                }
              }
              patterns_to_match = association.value.patterns_to_match
            }

          }
        }

      }
    }

  }
}

resource "azapi_update_resource" "frontdoor_system_identity" {
  type        = "Microsoft.Cdn/profiles@2023-02-01-preview"
  resource_id = azurerm_cdn_frontdoor_profile.this.id
  body = jsonencode({
    "identity" : {
      "type" : var.settings.profile.identity.type
      "identity_ids" : var.settings.profile.identity.identity_ids
    }
  })
  response_export_values = ["identity.principalId", "identity.tenantId"]

}


# resource "azurerm_role_assignment" "this" {
#   for_each             = try({ for n in var.settings.azurerm_role_assignment : n.name => n }, {})
#   scope                = each.value.scope
#   role_definition_name = each.value.role_definition_name
#   principal_id         = jsondecode(azapi_update_resource.frontdoor_system_identity.output).identity.principalId
# }
