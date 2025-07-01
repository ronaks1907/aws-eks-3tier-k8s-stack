variable "environment" {
  description = "Deployment environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "oidc_provider_url" {
  description = "OIDC provider URL for the EKS cluster (e.g., https://oidc.eks.<region>.amazonaws.com/id/XXXXXXXXXXXX)"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}
