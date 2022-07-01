resource "kubernetes_secret" "http-credentials" {
  depends_on = [
    azapi_update_resource.flux_install,
    azapi_update_resource.flux_config
  ]
  metadata {
    name = "http-credentials"
    namespace = "flux-system"
  }

  data = {
    username = "admin"
    password = "P4ssw0rd"
  }
}