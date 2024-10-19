resource "azurerm_cdn_profile" "this" {
  name                = var.settings.name
  location            = var.settings.location
  resource_group_name = var.settings.resource_group_name
  sku                 = var.settings.sku
  tags                = var.settings.tags
}

resource "azurerm_cdn_endpoint" "this" {
  for_each                      = try({ for n in var.settings.endpoint : n.name => n }, {})
  name                          = each.value.name
  profile_name                  = var.settings.name
  location                      = var.settings.location
  resource_group_name           = var.settings.resource_group_name
  is_http_allowed               = each.value.is_http_allowed
  is_https_allowed              = each.value.is_https_allowed
  is_compression_enabled        = each.value.is_compression_enabled
  content_types_to_compress     = each.value.content_types_to_compress
  querystring_caching_behaviour = each.value.querystring_caching_behaviour
  optimization_type             = each.value.optimization_type
  dynamic "geo_filter" {
    for_each = each.value.geo_filter != null ? [each.value.geo_filter] : []
    content {
      relative_path = geo_filter.value.relative_path
      action        = geo_filter.value.action
      country_codes = geo_filter.value.country_codes
    }
  }

  dynamic "origin" {
    for_each = each.value.origin != null ? [each.value.origin] : []
    content {
      name      = origin.value.name
      host_name = origin.value.host_name
    }
  }
  origin_host_header = each.value.origin_host_header
  origin_path        = each.value.origin_path
  probe_path         = each.value.probe_path
  tags               = var.settings.tags
  depends_on         = [azurerm_cdn_profile.this]
}

resource "azurerm_cdn_endpoint_custom_domain" "this" {
  for_each        = try({ for n in var.settings.custom_domain : n.name => n }, {})
  name            = each.key
  cdn_endpoint_id = azurerm_cdn_endpoint.this[each.value.cdn_endpoint_name].id
  host_name       = each.value.host_name
}