resource "azurerm_kubernetes_cluster_node_pool" "app_node_pool" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]
  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
  name                  = "apps"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vnet_subnet_id        = azurerm_subnet.nodes.id
  vm_size               = "Standard_B4ms"
  enable_auto_scaling   = true
  mode                  = "User"
  os_sku                = "CBLMariner"
  os_disk_size_gb       = 30
  node_count            = 3
  min_count             = 3
  max_count             = 6

  upgrade_settings {
    max_surge           = "25%"
  }

  node_taints = ["reservedFor=apps:NoSchedule"]
}

resource "azurerm_kubernetes_cluster_node_pool" "istio_node_pool" {
  depends_on = [
    azurerm_kubernetes_cluster.this
  ]

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

  name                  = "istio"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vnet_subnet_id        = azurerm_subnet.nodes.id
  vm_size               = "Standard_B4ms"
  enable_auto_scaling   = true
  mode                  = "User"
  os_sku                = "CBLMariner"
  os_disk_size_gb       = 30
  node_count            = 1
  min_count             = 1
  max_count             = 3

  upgrade_settings {
    max_surge           = "25%"
  }

  node_taints = ["reservedFor=istio-gateway:NoSchedule"]
}
