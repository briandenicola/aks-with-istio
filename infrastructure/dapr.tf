resource "azapi_resource" "dapr_install" {
  depends_on = [
    azapi_resource.flux_install
  ]

  type      = "Microsoft.KubernetesConfiguration/extensions@2022-11-01"
  name      = "dapr"
  parent_id = azurerm_kubernetes_cluster.this.id

  body = jsonencode({
    properties = {
      extensionType           = "microsoft.dapr"
      autoUpgradeMinorVersion = true
      scope = {
        cluster = {
          releaseNamespace = "dapr-system"
        }
      }
    }
  })
}
