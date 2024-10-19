variable "settings" {
  type = object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = string
    tags                = optional(map(string))
    endpoint = optional(list(object({
      name                      = string
      is_http_allowed           = optional(bool, true)
      is_https_allowed          = optional(bool, true)
      content_types_to_compress = optional(list(string))
      geo_filter = optional(object({
        relative_path = string
        action        = string
        country_codes = list(string)
      }))
      is_compression_enabled        = optional(bool, false)
      querystring_caching_behaviour = optional(string)
      optimization_type             = optional(string)
      origin = object({
        name       = string
        host_name  = string
        http_port  = optional(number, 80)
        https_port = optional(number, 443)
      })
      origin_host_header = optional(string)
      origin_path        = optional(string)
      probe_path         = optional(string)
      delivery_rule      = optional(string)
    })))
    custom_domain = optional(list(object({
      name              = string
      cdn_endpoint_name = string
      host_name         = string
      cdn_managed_https = optional(object({
        certificate_type = string
        protocol_type    = string
        tls_version      = optional(string, "TLS12")
      }))
      user_managed_https = optional(object({
        key_vault_certificate_id = optional(string)
        key_vault_secret_id      = optional(string)
        tls_version              = optional(string, "TLS12")
      }))
    })))
  })
}