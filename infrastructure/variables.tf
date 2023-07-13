variable "namespace" {
  description   = "The namespace for the workload identity"
  type          = string
  default       = "default"
}

variable "azure_rbac_group_object_id" {
  description = "GUID of the AKS admin Group"
  default     = "15390134-7115-49f3-8375-da9f6f608dce"
}

variable "service_mesh_type" {
  description = "Type of Service Mesh for cluster"
  default     = "istio"
}

variable "region" {
  description = "Region to deploy resources to"
  default     =  "southcentralus"
}

variable "vm_sku" {
  description = "The VM type for the system node pool"
  default     = "Standard_D4ads_v5"
}