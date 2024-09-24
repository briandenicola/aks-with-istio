variable "namespace" {
  description = "The default namespace for the applications"
  type        = string
  default     = "default"
}

variable "tags" {
  description = "The tag to be applied to all Resources"
}

variable "service_mesh_type" {
  description = "Type of Service Mesh for cluster"
  default     = "istio"
}

variable "region" {
  description = "Region to deploy resources to"
  default     = "southcentralus"
}

variable "zones" {
  description = "The values for the zones to deploy AKS to"
  default     = ["1"]
}

variable "vm_sku" {
  description = "The VM type for the node pools"
  default     = "Standard_D4d_v5"
}

variable "certificate_base64_encoded" {
  description = "TLS Certificate for Istio Ingress Gateway"
}

variable "certificate_password" {
  description = "Password for TLS Certificate"
}

variable "certificate_name" {
  description = "The name of the certificate to use for TLS"
  default     = "wildcard-certificate"
}
