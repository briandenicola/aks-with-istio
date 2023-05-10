resource "azurerm_kubernetes_cluster_extension" "flux" {
  depends_on = [
    azapi_update_resource.post-configs,
    azurerm_kubernetes_cluster_node_pool.app_node_pool,
    azurerm_kubernetes_cluster_node_pool.istio_node_pool
  ]
  name           = "flux"
  cluster_id     = azurerm_kubernetes_cluster.this.id
  extension_type = "microsoft.flux"
}

resource "azapi_resource" "flux_config" {
  depends_on = [
    azurerm_kubernetes_cluster_extension.flux
  ]

  type      = "Microsoft.KubernetesConfiguration/fluxConfigurations@2022-11-01"
  name      = "aks-flux-extension"
  parent_id = azurerm_kubernetes_cluster.this.id

  body = jsonencode({
    properties : {
      scope      = "cluster"
      namespace  = "flux-system"
      sourceKind = "GitRepository"
      suspend    = false
      gitRepository = {
        url                   = local.flux_repository
        timeoutInSeconds      = 600
        syncIntervalInSeconds = 300
        repositoryRef = {
          branch = "main"
        }
      }
      kustomizations : {
        istio-crd = {
          path                   = local.crd_path
          dependsOn              = []
          timeoutInSeconds       = 600
          syncIntervalInSeconds  = 120
          retryIntervalInSeconds = 300
          prune                  = true
        }
        istio-cfg = {
          path                   = local.istio_cfg_path
          dependsOn              = [
            "istio-crd"
          ]
          timeoutInSeconds       = 600
          syncIntervalInSeconds  = 120
          retryIntervalInSeconds = 300
          prune                  = true
        }
        istio-gw = {
          path                   = local.istio_gw_path
          dependsOn              = [
            "istio-cfg"
          ]
          timeoutInSeconds       = 600
          syncIntervalInSeconds  = 120
          retryIntervalInSeconds = 300
          prune                  = true
        }
        apps = {
          path                   = local.app_path
          dependsOn              = [
            "istio-cfg"
          ]
          timeoutInSeconds       = 600
          syncIntervalInSeconds  = 120
          retryIntervalInSeconds = 300
          prune                  = true
        }
      }
    }
  })
}