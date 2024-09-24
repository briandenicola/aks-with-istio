resource "azapi_update_resource" "cluster_updates" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]

  type        = "Microsoft.ContainerService/managedClusters@2024-01-02-preview"
  resource_id = azurerm_kubernetes_cluster.this.id

  body = jsonencode({
    properties = {
      metricsProfile = {
        costAnalysis = {
          enabled = true
        }
      }
      networkProfile = {
        monitoring = {
          enabled = true
        }
      }
    }
  })
}

resource "azurerm_monitor_data_collection_rule_association" "this" {
  depends_on = [
    module.azure_monitor,
    azurerm_kubernetes_cluster.this
  ]
  name                    = "${local.resource_name}-ama-datacollection-rules-association"
  target_resource_id      = azurerm_kubernetes_cluster.this.id
  data_collection_rule_id = module.azure_monitor.DATA_COLLECTION_RULES_ID
}

resource "azurerm_monitor_data_collection_rule_association" "container_insights" {
  name                        = "${local.resource_name}-ama-container-insights-rules-association"
  target_resource_id          = azurerm_kubernetes_cluster.this.id
  data_collection_rule_id     = module.azure_monitor.DATA_COLLECTION_RULE_CONTAINER_INSIGHTS_ID
}