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

#https://grafana.com/grafana/dashboards/18814-kubernetes-networking/
#https://grafana.com/grafana/dashboards/16611-cilium-metrics/