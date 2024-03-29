# resource "azapi_resource" "azure_monitor_workspace" {
#   type      = "microsoft.monitor/accounts@2021-06-03-preview"
#   name      = "${local.resource_name}-workspace"
#   parent_id = azurerm_resource_group.this.id

#   location = azurerm_resource_group.this.location

#   body = jsonencode({
#   })
# }

# locals {
#   am_workspace_id = "${data.azurerm_subscription.current.id}/resourcegroups/${azurerm_resource_group.this.name}/providers/microsoft.monitor/accounts/${local.resource_name}-workspace"
# }

resource "azurerm_monitor_workspace" "this" {
  name                = "${local.resource_name}-workspace"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

resource "azurerm_monitor_data_collection_endpoint" "this" {
  name                          = "${local.resource_name}-ama-datacollection-ep"
  resource_group_name           = azurerm_resource_group.this.name
  location                      = azurerm_resource_group.this.location
  kind                          = "Linux"
  public_network_access_enabled = true
}

resource "azurerm_monitor_data_collection_rule" "azuremonitor" {
  name                = "${local.resource_name}-ama-datacollection-rules"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  depends_on = [
    azurerm_monitor_workspace.this,
    azurerm_monitor_data_collection_endpoint.this
  ]
  kind                        = "Linux"
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.this.id

  destinations {
    monitor_account {
      monitor_account_id = azurerm_monitor_workspace.this.id
      name               = "MonitoringAccount"
    }
  }

  data_flow {
    destinations = ["MonitoringAccount"]
    streams      = ["Microsoft-PrometheusMetrics"]
  }

  data_sources {
    prometheus_forwarder {
      name    = "PrometheusDataSource"
      streams = ["Microsoft-PrometheusMetrics"]
    }
  }
}

# resource "azapi_resource" "monitor_datacollection_rule_associations" {
#   type = "Microsoft.Insights/dataCollectionRuleAssociations@2021-09-01-preview"
#   name = "${local.resource_name}-ama-datacollection-rules-association"
#   parent_id = azurerm_kubernetes_cluster.this.id
#   body = jsonencode({
#     properties = {
#       dataCollectionRuleId = azurerm_monitor_data_collection_rule.azuremonitor.id
#     }
#   })
# }

resource "azurerm_monitor_data_collection_rule_association" "this" {
  name                    = "${local.resource_name}-ama-datacollection-rules-association"
  target_resource_id      = azurerm_kubernetes_cluster.this.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.azuremonitor.id
}
