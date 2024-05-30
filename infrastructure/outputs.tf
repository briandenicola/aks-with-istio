output "AKS_RESOURCE_GROUP" {
    value = azurerm_kubernetes_cluster.this.resource_group_name
    sensitive = false
}

output "AKS_CLUSTER_NAME" {
    value = azurerm_kubernetes_cluster.this.name
    sensitive = false
}

output "AI_CONNECTION_STRING" {
    value = azurerm_application_insights.this.connection_string
    sensitive = true
}

output "KEYVAULT_NAME" {
    value = azurerm_key_vault.this.name
}

output "INGRESS_CLIENT_ID" {
    value = azurerm_user_assigned_identity.aks_service_mesh_identity.client_id
}
