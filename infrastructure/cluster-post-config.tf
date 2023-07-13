resource "azapi_update_resource" "istio_ingressgateway" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]

  type        = "Microsoft.ContainerService/managedClusters@2023-03-02-preview"
  resource_id = azurerm_kubernetes_cluster.this.id

  body = jsonencode({
    properties = {
      networkProfile = {
        monitoring = {
          enabled = true
        }
      }
      serviceMeshProfile ={
        istio = {
          components = {
            ingressGateways = [{
              enabled = true,
              mode    = "Internal"
            }]
          }
        },
      }
    }
  })
}

#https://grafana.com/grafana/dashboards/18814-kubernetes-networking/