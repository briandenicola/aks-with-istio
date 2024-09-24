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
  environment_type          = "Production"
}

resource "azurerm_resource_group" "this" {
  name     = "${local.resource_name}_rg"
  location = local.location

  tags = {
    Application = var.tags
    Components  = "aks; flux; istio; kured; dapr"
    DeployedOn  = timestamp()
  }
}

module "azure_monitor" {
  source               = "./observability"
  region               = var.region
  resource_name        = local.resource_name
  tags                 = var.tags
  sdlc_environment     = local.environment_type
}