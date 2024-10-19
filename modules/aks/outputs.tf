output "client_certificate" {
  description = "Base64 encoded public certificate used by clients to authenticate to the Kubernetes cluster."
  value       = azurerm_kubernetes_cluster.this.kube_config.0.client_certificate
  sensitive   = true
}

output "kube_config" {
  description = "Raw Kubernetes config to be used by kubectl and other compatible tools."
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "id" {
  description = "The Kubernetes Managed Cluster ID."
  value       = azurerm_kubernetes_cluster.this.id
}

output "aks_nodes_pools_ids" {
  description = "Ids of AKS nodes pools"
  value       = [for i in azurerm_kubernetes_cluster_node_pool.this : i.id]
}

output "kube_identity" {
  description = "Object Id of managed identity"
  value       = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}

# output "mngd_identity_principal_id" {
#   description = "Object Id of managed identity"
#   value       = azurerm_user_assigned_identity.aks.principal_id
# }
# output "mngd_identity_client_id" {
#   description = "Client Id of managed identity"
#   value       = azurerm_user_assigned_identity.aks.client_id
# }


output "node_resource_group" {
  description = "Resource Group Name of the AKS Nodes"
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}


# output "cluster_identity" {
#   description = "Kubelet Identity"
#   value       = azurerm_user_assigned_identity.aks.principal_id
# }

