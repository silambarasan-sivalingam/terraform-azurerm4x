variable "settings" {
  description = "ampls configuration."
  type = object({
    name                = string
    resource_group_name = string
    location            = string

    private_endpoint = object({
      endpoint_name        = string
      subnet_id            = string
      connection_name      = string
      private_dns_zone_ids = list(string)
    })

    tags = optional(map(string), null)
  })
}
