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
| [azurerm_network_interface.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_windows_virtual_machine.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_settings"></a> [settings](#input\_settings) | vm configuration. | <pre>object({<br>    name                     = string<br>    location                 = string<br>    resource_group_name      = string<br>    admin_username           = string<br>    admin_password           = string<br>    size                     = string<br>    availability_set_id      = optional(string, null)<br>    enable_automatic_updates = optional(bool, true)<br>    license_type             = optional(string, "None")<br>    computer_name            = optional(string, null)<br>    tags                     = optional(map(string), null)<br>    os_disk = object({<br>      caching                   = string<br>      storage_account_type      = string<br>      disk_size_gb              = optional(string, "127")<br>      write_accelerator_enabled = optional(bool, false)<br>    })<br><br>    source_image_reference = object({<br>      publisher = string<br>      offer     = string<br>      sku       = string<br>      version   = string<br>    })<br><br>    network_interface = object({<br>      name                          = string<br>      enable_accelerated_networking = optional(bool, false)<br>      ip_configuration = object({<br>        subnet_id                     = string<br>        private_ip_address_allocation = optional(string, "Dynamic")<br>        private_ip_address            = optional(string, null)<br>        primary                       = optional(bool, true)<br>      })<br>    })<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Windows Virtual Machine. |
| <a name="output_mac_address"></a> [mac\_address](#output\_mac\_address) | The Media Access Control (MAC) Address of the Network Interface. |
| <a name="output_nicid"></a> [nicid](#output\_nicid) | The ID of the Network Interface. |
| <a name="output_private_ip_address"></a> [private\_ip\_address](#output\_private\_ip\_address) | The first private IP address of the network interface. |
| <a name="output_private_ip_addresses"></a> [private\_ip\_addresses](#output\_private\_ip\_addresses) | The private IP addresses of the network interface. |
| <a name="output_virtual_machine_id"></a> [virtual\_machine\_id](#output\_virtual\_machine\_id) | A 128-bit identifier which uniquely identifies this Virtual Machine. |
<!-- END_TF_DOCS -->