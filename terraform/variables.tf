variable "environment" {
  description = "The name of the deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (e.g., 10.0.0.0/16)"
  type        = string
}

variable "region" {
  description = "AWS region for resource deployment (e.g., ap-south-1)"
  type        = string
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for the second public subnet"
  type        = string
}

variable "app_subnet_1_cidr" {
  description = "CIDR block for the first private application subnet"
  type        = string
}

variable "app_subnet_2_cidr" {
  description = "CIDR block for the second private application subnet"
  type        = string
}

variable "db_subnet_1_cidr" {
  description = "CIDR block for the first private database subnet"
  type        = string
}

variable "db_subnet_2_cidr" {
  description = "CIDR block for the second private database subnet"
  type        = string
}
