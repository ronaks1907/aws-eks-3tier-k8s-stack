# Get Available AZs
data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "production_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    Name        = "${var.environment}-vpc"
    Environment = "${var.environment}"
    Terraform   = "true"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "production_igw" {
  vpc_id = aws_vpc.production_vpc.id
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
    Terraform   = "true"
  }
}

# Public Subnets
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.production_vpc.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet-1"
    Environment = var.environment
    Terraform   = "true"
    Type        = "Public"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.production_vpc.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-public-subnet-2"
    Environment = var.environment
    Terraform   = "true"
    Type        = "Public"
  }
}

# App Subnets
resource "aws_subnet" "app_subnet_1" {
  vpc_id            = aws_vpc.production_vpc.id
  cidr_block        = var.app_subnet_1_cidr
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name        = "${var.environment}-app-subnet-1"
    Environment = var.environment
    Terraform   = "true"
    Type        = "Private"
  }
}

resource "aws_subnet" "app_subnet_2" {
  vpc_id            = aws_vpc.production_vpc.id
  cidr_block        = var.app_subnet_2_cidr
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name        = "${var.environment}-app-subnet-2"
    Environment = var.environment
    Terraform   = "true"
    Type        = "Private"
  }
}

# DB Subnets
resource "aws_subnet" "db_subnet_1" {
  vpc_id                  = aws_vpc.production_vpc.id
  cidr_block              = var.db_subnet_1_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-db-subnet-1"
    Environment = var.environment
    Terraform   = "true"
    Type        = "Private"
  }
}

resource "aws_subnet" "db_subnet_2" {
  vpc_id                  = aws_vpc.production_vpc.id
  cidr_block              = var.db_subnet_2_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-db-subnet-2"
    Environment = var.environment
    Terraform   = "true"
    Type        = "Private"
  }
}

# Create an Elastic IPs for the 2 NAT Gateway
resource "aws_eip" "nat_eip_1" {
  domain = "vpc"
  tags = {
    Name      = "${var.environment}-nat-eip-1"
    Terraform = "true"
  }
}
resource "aws_eip" "nat_eip_2" {
  domain = "vpc"
  tags = {
    Name      = "${var.environment}-nat-eip-2"
    Terraform = "true"
  }
}

# NAT Gateway for Public-Subnet-1 AZ-1
resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name      = "${var.environment}-nat-gateway-1"
    Terraform = "true"
  }
  depends_on = [aws_internet_gateway.production_igw]
}

# NAT Gateway for Public-Subnet-2 AZ-2
resource "aws_nat_gateway" "nat_gw_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id
  tags = {
    Name      = "${var.environment}-nat-gateway-2"
    Terraform = "true"
  }
  depends_on = [aws_internet_gateway.production_igw]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.production_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.production_igw.id
  }
  tags = {
    Name      = "${var.environment}-public-route-table"
    Terraform = "true"
  }
}

# App (Private) Route Table - Use NAT Gateway 1 (AZ-1)
resource "aws_route_table" "app" {
  vpc_id = aws_vpc.production_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_1.id
  }
  tags = {
    Name      = "${var.environment}-app-route-table-az1"
    Terraform = "true"
  }
}

# App (Private) Route Table - Use NAT Gateway 2 (AZ-2)
resource "aws_route_table" "app1" {
  vpc_id = aws_vpc.production_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_2.id
  }
  tags = {
    Name      = "${var.environment}-app-route-table-az2"
    Terraform = "true"
  }
}

# Associate route tables with subnets

# Public
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public.id
}

# App
resource "aws_route_table_association" "private_app_1" {
  subnet_id      = aws_subnet.app_subnet_1.id
  route_table_id = aws_route_table.app.id
}

resource "aws_route_table_association" "private_app_2" {
  subnet_id      = aws_subnet.app_subnet_2.id
  route_table_id = aws_route_table.app1.id
}

# DB
resource "aws_route_table_association" "private_db_1" {
  subnet_id      = aws_subnet.db_subnet_1.id
  route_table_id = aws_route_table.app.id
}

resource "aws_route_table_association" "private_db_2" {
  subnet_id      = aws_subnet.db_subnet_2.id
  route_table_id = aws_route_table.app1.id
}
