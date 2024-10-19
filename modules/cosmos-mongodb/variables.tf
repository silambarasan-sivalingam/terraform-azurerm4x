variable "settings" {
  description = "cosmosdb account configuration"

  type = object({
    name                = string
    location            = string
    resource_group_name = string
    account_name        = string
    throughput          = string
    autoscale_settings = optional(object({
      max_throughput = number
    }))


    cosmosdb_mongo_collection = optional(list(object({

      name                = string
      shard_key           = string
      throughput          = string
      default_ttl_seconds = string

      index = optional(object({
        keys   = list(string)
        unique = bool
      }))


      autoscale_settings = optional(object({
        max_throughput = number
      }))

    })))

  })
}
