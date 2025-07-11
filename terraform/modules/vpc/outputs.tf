output "db_subnet_1_id" {
  description = "ID of the first DB subnet"
  value       = aws_subnet.db_subnet_1.id
}

output "db_subnet_2_id" {
  description = "ID of the second DB subnet"
  value       = aws_subnet.db_subnet_2.id
}

output "vpc_id" {
  description = "ID of the production VPC"
  value       = aws_vpc.production_vpc.id
}

output "app_subnet_1_id" {
  description = "ID of the first App subnet"
  value       = aws_subnet.app_subnet_1.id
}

output "app_subnet_2_id" {
  description = "ID of the second App subnet"
  value       = aws_subnet.app_subnet_2.id
}