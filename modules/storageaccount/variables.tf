variable "settings" {
  description = "Storage account configurations"
  type = object({
    name                              = string
    location                          = string
    resource_group_name               = string
    account_kind                      = optional(string, "StorageV2")
    account_tier                      = optional(string, "Standard")
    account_replication_type          = optional(string, "GRS")
    access_tier                       = optional(string)
    edge_zone                         = optional(string, null)
    shared_access_key_enabled         = optional(bool, true)
    large_file_share_enabled          = optional(bool, false)
    nfsv3_enabled                     = optional(bool, false)
    tags                              = optional(map(string), null)
    public_network_access_enabled     = optional(bool, false)
    infrastructure_encryption_enabled = optional(bool)
    queue_encryption_key_type         = optional(string)
    table_encryption_key_type         = optional(string)
    # dns_endpoint_type             = optional(string, "AzureDnsZone")

    network_rules = optional(list(object({
      virtual_network_subnet_ids = list(string)
      ip_rules                   = list(string)
      default_action             = optional(string, "Deny")
    })))

    blob_properties = optional(object({
      delete_retention_policy = optional(object({
        days = optional(number)
      }))
      container_delete_retention_policy = optional(object({
        days = optional(number)
      }))
      versioning_enabled       = optional(bool)
      last_access_time_enabled = optional(bool)
      change_feed_enabled      = optional(bool)
    }))


    static_website = optional(object({
      index_document     = string
      error_404_document = optional(string)
    }))

    customer_managed_key = optional(object({
      key_vault_key_id          = string
      user_assigned_identity_id = string
    }))


    routing = optional(object({
      publish_internet_endpoints  = string
      publish_microsoft_endpoints = string
      choice                      = string
    }))

    identity = optional(object({
      type         = string
      identity_ids = list(string)
    }))


    containers = optional(list(object({
      name = string
    })))

    file_shares = optional(list(object({
      name             = string
      quota_in_gb      = optional(number, 50)
      enabled_protocol = optional(string)
      metadata         = optional(map(string))
      acl = optional(list(object({
        id          = string
        permissions = string
        start       = optional(string)
        expiry      = optional(string)
      })))
    })))

    queues = optional(list(object({
      name = string
    })))

    tables = optional(list(object({
      name = string
    })))

    private_endpoint = optional(object({
      resource_group_name  = optional(string)
      subnet_id            = string
      private_dns_zone_ids = optional(list(string))
    }))

    private_endpoint_secondary = optional(list(object({
      endpoint_name        = string
      subnet_id            = string
      connection_name      = string
      resource_group_name  = optional(string)
      private_dns_zone_ids = optional(list(string))
      subresource_names    = list(string)
    })))

  })
}
