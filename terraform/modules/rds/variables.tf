variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "db_subnet_1_id" {
  description = "The ID of the first private subnet for the database"
  type        = string
}

variable "db_subnet_2_id" {
  description = "The ID of the second private subnet for the database"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC in which the database subnets exist"
  type        = string
}
