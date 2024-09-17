provider "aws" {
  region = var.aws_region
}

# Criar a VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "fastfood-vpc"
  }
}

# Criar as Subnets
resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_1_cidr
  availability_zone = var.availability_zone_1
  tags = {
    Name = "subnet-1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_2_cidr
  availability_zone = var.availability_zone_2
  tags = {
    Name = "subnet-2"
  }
}

# Criar o Security Group
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-security-group"
  }
}

# Criar o grupo de subnets para o RDS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = var.subnet_group_name
  subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  tags = {
    Name = "rds-subnet-group"
  }
}

# Criar o banco de dados RDS PostgreSQL
resource "aws_db_instance" "postgres" {
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "13.14"
  instance_class          = "db.t3.micro"
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  parameter_group_name    = "default.postgres13"
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
}