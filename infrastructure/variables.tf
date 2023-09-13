variable "namespace" {
  description = "The namespace for the workload identity"
  type        = string
  default     = "default"
}

variable "service_mesh_type" {
  description = "Type of Service Mesh for cluster"
  default     = "istio"
}

variable "region" {
  description = "Region to deploy resources to"
  default     = "southcentralus"
}

variable "vm_sku" {
  description = "The VM type for the system node pool"
  default     = "Standard_D4ads_v5"
}

variable "certificate_base64_encoded" {
  description = "TLS Certificate for Istio Ingress Gateway"
}

variable "certificate_password" {
  description = "Password for TLS Certificate"
}

variable "certificate_name" {
  description      = "The name of the certificate to use for TLS"
  default = "wildcard-certificate"
}
