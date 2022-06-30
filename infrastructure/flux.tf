resource "azapi_update_resource" "flux_install" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]

  type        = "Microsoft.KubernetesConfiguration/extensions@2021-09-01"
  resource_id = azurerm_kubernetes_cluster.this.id

  body = jsonencode({
    properties = {
        extensionType = "microsoft.flux"
        autoUpgradeMinorVersion = true
        scope = {
            cluster = {
                releaseNamespace = "flux-system"
            }
        }
    }
  })
}

resource "azapi_update_resource" "flux_config" {
    depends_on = [
        azapi_update_resource.flux_install
    ]

    type        = "Microsoft.KubernetesConfiguration/extensions@2021-09-01"
    resource_id = azurerm_kubernetes_cluster.this.id

    body = jsonencode({})
    #  properties: {
    #    scope: 'cluster'
    #    namespace: 'gitops-demo'
    #    sourceKind: 'GitRepository'
    #    suspend: false
    #    gitRepository: {
    #      url: 'https://github.com/fluxcd/flux2-kustomize-helm-example'
    #      timeoutInSeconds: 600
    #      syncIntervalInSeconds: 600
    #      repositoryRef: {
    #        branch: 'main'
    #      }
    #
    #    }
    #    kustomizations: {
    #      infra: {
    #        path: './infrastructure'
    #        dependsOn: []
    #        timeoutInSeconds: 600
    #        syncIntervalInSeconds: 600
    #        validation: 'none'
    #        prune: true
    #      }
    #    }
    #  }
    #}
}