output "id" {
  description = "AKS resource ID."
  value       = azurerm_kubernetes_cluster.this.id
}

output "kubelet_identity" {
  description = "AKS kubelet identity."
  value       = azurerm_kubernetes_cluster.this.kubelet_identity
}
