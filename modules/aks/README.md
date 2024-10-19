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
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_settings"></a> [settings](#input\_settings) | Configure AKS resources | <pre>object({<br>    location                      = string<br>    resource_group_name           = string<br>    name                          = string<br>    kubernetes_version            = optional(string, "1.25.0")<br>    sku_tier                      = optional(string, "Standard")<br>    node_resource_group           = optional(string, null)<br>    private_cluster_enabled       = bool<br>    private_dns_zone_id           = optional(string, null)<br>    azure_policy_enabled          = optional(bool, true)<br>    public_network_access_enabled = optional(bool, false)<br><br>    default_node_pool = object({<br>      name                  = optional(string, "default")<br>      node_count            = number<br>      vm_size               = optional(string, "Standard_D2_v2")<br>      enable_auto_scaling   = optional(bool, false)<br>      enable_node_public_ip = optional(bool, false)<br>      vnet_subnet_id        = string<br>    })<br><br>    identity = optional(object({<br>      type = optional(string, "SystemAssigned")<br>    }))<br><br>    network_profile = object({<br>      load_balancer_sku = optional(string, "standard")<br>      service_cidr      = string<br>      dns_service_ip    = string<br>    })<br><br>    azure_active_directory_role_based_access_control = optional(object({<br>      managed            = optional(bool, true)<br>      azure_rbac_enabled = optional(bool, true)<br>    }))<br><br>    key_vault_secrets_provider = optional(object({<br>      secret_rotation_enabled  = optional(bool, true)<br>      secret_rotation_interval = optional(string, "2m")<br>    }), null)<br><br>    azurerm_kubernetes_cluster_node_pool = list(object({<br>      name                   = optional(string, "internal")<br>      vm_size                = optional(string, "Standard_DS2_v2")<br>      node_count             = optional(number, 1)<br>      os_type                = optional(string, "Linux")<br>      zones                  = optional(list(number), [1, 2, 3])<br>      enable_auto_scaling    = optional(bool, false)<br>      min_count              = optional(number, 1)<br>      max_count              = optional(number, 10)<br>      type                   = optional(string, "VirtualMachineScaleSets")<br>      node_taints            = optional(list(any), null)<br>      node_labels            = optional(map(any), null)<br>      orchestrator_version   = optional(string, null)<br>      priority               = optional(string, null)<br>      enable_host_encryption = optional(bool, null)<br>      eviction_policy        = optional(string, null)<br>      os_disk_type           = optional(string, "Managed")<br>      os_disk_size_gb        = optional(number, 128)<br>      enable_node_public_ip  = optional(bool, false)<br>      vnet_subnet_id         = optional(string, null)<br>      tag                    = optional(map(string), null)<br>    }))<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks_id"></a> [aks\_id](#output\_aks\_id) | The Kubernetes Managed Cluster ID. |
| <a name="output_aks_nodes_pools_ids"></a> [aks\_nodes\_pools\_ids](#output\_aks\_nodes\_pools\_ids) | Ids of AKS nodes pools |
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster. |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | Raw Kubernetes config to be used by kubectl and other compatible tools. |
| <a name="output_kube_identity"></a> [kube\_identity](#output\_kube\_identity) | Object Id of managed identity |
<!-- END_TF_DOCS -->