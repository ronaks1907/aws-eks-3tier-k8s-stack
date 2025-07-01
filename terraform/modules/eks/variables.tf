variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where resources will be deployed"
  type        = string
}

variable "app_subnet_1_id" {
  description = "The ID of the first subnet to be used for application load balancer"
  type        = string
}

variable "app_subnet_2_id" {
  description = "The ID of the second subnet to be used for application load balancer"
  type        = string
}

variable "region" {
  description = "AWS region where resources will be deployed (e.g., ap-south-1)"
  type        = string
}

variable "instance_types" {
  description = "List of EC2 instance types for EKS nodes or other compute resources"
  type        = list(string)
  default     = ["t3.medium"]
}
