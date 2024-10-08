resource "azurerm_kubernetes_cluster_node_pool" "app_node_pool" {
  depends_on = [
    azapi_update_resource.cluster_updates
  ]

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

  name                  = "apps"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vnet_subnet_id        = azurerm_subnet.nodes.id
  zones                 = local.zones
  vm_size               = var.vm_sku
  auto_scaling_enabled  = true
  mode                  = "User"
  os_sku                = "AzureLinux"
  os_disk_type          = "Ephemeral"
  os_disk_size_gb       = 100
  max_pods              = 250
  node_count            = 1
  min_count             = 1
  max_count             = 3

  upgrade_settings {
    max_surge = "33%"
  }

  node_taints = ["reservedFor=apps:NoSchedule"]
}

# resource "azurerm_kubernetes_cluster_node_pool" "istio_node_pool" {
#   depends_on = [
#     azapi_update_resource.post-configs
#   #  azurerm_kubernetes_cluster.this
#   ]

#   lifecycle {
#     ignore_changes = [
#       node_count
#     ]
#   }

#   name                  = "istio"
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
#   vnet_subnet_id        = azurerm_subnet.nodes.id
#   vm_size               = "Standard_B4ms"
#   enable_auto_scaling   = true
#   mode                  = "User"
#   os_sku                = "Mariner"
#   os_disk_type          = "Ephemeral"
#   os_disk_size_gb       = 30
#   node_count            = 1
#   min_count             = 1
#   max_count             = 3

#   upgrade_settings {
#     max_surge           = "25%"
#   }

#   node_taints = ["reservedFor=istio-gateway:NoSchedule"]
# }
