variable "settings" {
  description = "mssql failover"

  type = object({
    name      = string
    server_id = string
    databases = list(string)
    tags      = optional(map(string))

    partner_server = object({
      id = string
    })

    read_write_endpoint_failover_policy = object({
      mode          = string
      grace_minutes = number
    })
  })
}
