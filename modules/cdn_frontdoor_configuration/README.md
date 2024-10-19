<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_cdn_frontdoor_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_endpoint) | resource |
| [azurerm_cdn_frontdoor_firewall_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_firewall_policy) | resource |
| [azurerm_cdn_frontdoor_profile.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_profile) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_settings"></a> [settings](#input\_settings) | Front Door configuration. | <pre>object({<br>    dns_id = optional(string)<br>    profile = object({<br>      name                     = string<br>      resource_group_name      = string<br>      sku_name                 = string<br>      response_timeout_seconds = optional(string, 120)<br>      tags                     = optional(map(string), null)<br>    })<br>    secret = optional(object({<br>      enabled           = bool<br>      name              = string<br>      kv_certificate_id = string<br>    }))<br>    custom_domain = optional(object({<br>      name      = string<br>      host_name = string<br>      tls = object({<br>        certificate_type    = string<br>        minimum_tls_version = string<br>      })<br>    }))<br>    endpoint = optional(object({<br>      name    = string<br>      enabled = bool<br>    }))<br>    firewall = optional(object({<br>      name                              = string<br>      resource_group_name               = string<br>      location                          = string<br>      enabled                           = optional(bool, true)<br>      mode                              = string<br>      redirect_url                      = optional(string)<br>      custom_block_response_status_code = optional(number)<br>      custom_block_response_body        = optional(string)<br>      custom_rule = optional(list(object({<br>        name     = string<br>        action   = string<br>        enabled  = optional(bool)<br>        priority = optional(number)<br>        type     = string<br>        match_condition = list(object({<br>          match_variable     = string<br>          match_values       = list(string)<br>          operator           = string<br>          selector           = optional(string)<br>          negation_condition = optional(string)<br>          transforms         = optional(list(string))<br>        }))<br>        rate_limit_duration_in_minutes = optional(number, 1)<br>        rate_limit_threshold           = optional(number, 10)<br>      })))<br>      managed_rule = optional(list(object({<br>        type    = optional(string)<br>        version = string<br>        action  = string<br>        exclusion = optional(list(object({<br>          match_variable = string<br>          operator       = string<br>          selector       = string<br>        })))<br>        override = optional(list(object({<br>          rule_group_name = string<br>          override_exclusion = optional(list(object({<br>            match_variable = string<br>            operator       = string<br>            selector       = string<br>          })))<br>          rule = optional(list(object({<br>            rule_id = string<br>            action  = string<br>            enabled = optional(bool, false)<br>            override_rule_exclusion = optional(list(object({<br>              match_variable = string<br>              operator       = string<br>              selector       = string<br>            })))<br>          })))<br>        })))<br>      })))<br>    }))<br>    tags = optional(map(string), null)<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_frontdoor_endpoint_id"></a> [frontdoor\_endpoint\_id](#output\_frontdoor\_endpoint\_id) | The id of the front door endpoint. |
| <a name="output_frontdoor_firewall_policy_id"></a> [frontdoor\_firewall\_policy\_id](#output\_frontdoor\_firewall\_policy\_id) | The id of the front door firewall policy. |
| <a name="output_frontdoor_id"></a> [frontdoor\_id](#output\_frontdoor\_id) | The id of the front door created. |
<!-- END_TF_DOCS -->