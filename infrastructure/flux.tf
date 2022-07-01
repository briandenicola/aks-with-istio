resource "azapi_resource" "flux_install" {
    depends_on = [
        azurerm_kubernetes_cluster.this
    ]

    type = "Microsoft.KubernetesConfiguration/extensions@2021-09-01"
    name = "flux"
    parent_id = azurerm_kubernetes_cluster.this.id

    body = jsonencode({
        properties = {
            extensionType = "microsoft.flux"
            autoUpgradeMinorVersion = true
        }
    })
}

resource "azapi_resource" "flux_config" {
    depends_on = [
        azapi_resource.flux_install
    ]

    type        = "Microsoft.KubernetesConfiguration/fluxConfigurations@2022-03-01"
    name        = "aks-fluxv2-extension"
    parent_id   = azurerm_kubernetes_cluster.this.id

    body = jsonencode({
        properties: {
            scope         = "cluster"
            namespace     = "flux-system"
            sourceKind    = "GitRepository"
            suspend       = false
            gitRepository = {
                url                     = "https://github.com/briandenicola/aks-fluxv2-extension"
                timeoutInSeconds        = 600
                syncIntervalInSeconds   = 300
                repositoryRef           = {
                    branch = "main"
                }
            }
            kustomizations: {
                aks = {
                    path                    = "./clusters/aks"
                    dependsOn               = []
                    timeoutInSeconds        = 600
                    syncIntervalInSeconds   = 300
                    retryIntervalInSeconds  = 300
                    prune                   = true
                }
            }
        }
    })
}