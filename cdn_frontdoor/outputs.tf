output "frontdoor_id" {
  description = "The id of the front door created."
  value       = azurerm_cdn_frontdoor_profile.this.id
}

output "frontdoor_firewall_policy_id" {
  description = "The id of the front door firewall policy."
  value       = azurerm_cdn_frontdoor_firewall_policy.this.id
}
