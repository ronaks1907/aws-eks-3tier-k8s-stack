variable "oidc_provider_url" {
  description = "OIDC provider URL for the EKS cluster (e.g., https://oidc.eks.<region>.amazonaws.com/id/XXXXXXXXXXXXX)"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC in which the EKS cluster and ALB will be deployed"
  type        = string
}

variable "region" {
  description = "AWS region where the resources will be deployed (e.g., ap-south-1)"
  type        = string
}

variable "app_subnet_1_id" {
  description = "First subnet ID for the application load balancer"
  type        = string
}

variable "app_subnet_2_id" {
  description = "Second subnet ID for the application load balancer"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}
