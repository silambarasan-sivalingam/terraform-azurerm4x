variable "settings" {
  description = "VNET Peering configuration"
  type = object({
    name                      = string
    resource_group_name       = string
    virtual_network_name      = string
    remote_virtual_network_id = string
    allow_gateway_transit     = optional(bool)
    use_remote_gateways       = optional(bool)
  })
}