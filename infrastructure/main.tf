data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "http" "myip" {
  url = "http://checkip.amazonaws.com/"
}

resource "random_id" "this" {
  byte_length = 2
}

resource "random_pet" "this" {
  length    = 1
  separator = ""
}

resource "random_integer" "vnet_cidr" {
  min = 25
  max = 250
}

resource "random_integer" "services_cidr" {
  min = 64
  max = 99
}

resource "random_integer" "pod_cidr" {
  min = 100
  max = 127
}

locals {
  location                  = var.region
  resource_name             = "${random_pet.this.id}-${random_id.this.dec}"
  aks_name                  = "${local.resource_name}-aks"
  app_path                  = "./clusters/cluster-01"
  crd_path                  = "./clusters/common/customresourcedefinitions"
  istio_cfg_path            = "./clusters/common/istio/configuration"
  istio_gw_path             = "./clusters/common/istio/gateway"
  flux_repository           = "https://github.com/briandenicola/aks-with-istio"
  vnet_cidr                 = cidrsubnet("10.0.0.0/8", 8, random_integer.vnet_cidr.result)
  api_subnet_cidir          = cidrsubnet(local.vnet_cidr, 12, 1)
  nodes_subnet_cidir        = cidrsubnet(local.vnet_cidr, 8, 2)
  aks_service_mesh_identity = "${local.aks_name}-${var.service_mesh_type}-pod-identity"
}

resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = local.location

  tags = {
    Application = "httpdemo"
    Components  = "aks; flux; istio; kured; dapr"
    DeployedOn  = timestamp()
  }
}
