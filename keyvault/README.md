<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_settings"></a> [settings](#input\_settings) | Key vault configuration. | <pre>object({<br>    azurerm_key_vault_name      = string<br>    location                    = string<br>    resource_group_name         = string<br>    sku_name                    = optional(string, "standard")<br>    purge_protection_enabled    = optional(bool, false)<br>    tags                        = optional(map(string), null)<br>    enabled_for_disk_encryption = optional(bool, true)<br>    network_rules = optional(object({<br>      default_action             = string<br>      ip_rules                   = optional(list(string))<br>      virtual_network_subnet_ids = optional(list(string))<br>    }))<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The id of the key vault created. |
| <a name="output_name"></a> [name](#output\_name) | The name of the key vault created. |
| <a name="output_url"></a> [url](#output\_url) | The url of the key vault created. |
<!-- END_TF_DOCS -->