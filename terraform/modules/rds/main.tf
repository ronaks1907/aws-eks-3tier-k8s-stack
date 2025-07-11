data "aws_secretsmanager_secret" "rds_password" {
  name = "${var.environment}-rds-password"
}

data "aws_secretsmanager_secret_version" "rds_password_version" {
  secret_id = data.aws_secretsmanager_secret.rds_password.id
}

locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds_password_version.secret_string)
}

resource "aws_db_instance" "default" {
  allocated_storage      = 20
  db_name                = "mydb"
  engine                 = "postgres"
  engine_version         = "17.5"
  instance_class         = "db.t3.micro"
  username               = local.db_credentials.username
  password               = local.db_credentials.password
  parameter_group_name   = "default.postgres17"
  skip_final_snapshot    = true
  publicly_accessible    = false
  storage_encrypted      = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  tags = {
    Name        = "${var.environment}-postgres-db"
    Environment = var.environment
    Project     = "true"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = [var.db_subnet_1_id, var.db_subnet_2_id]

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
    Terraform   = "true"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "prod-db-sg"
  description = "Allow access to RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.app_sg.id] # App layer SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prod-db-sg"
  }
}

