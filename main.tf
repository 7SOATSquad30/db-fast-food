provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "aws-fastfood-fiap-terraform-tfstate"
    key    = "fast-food-db/terraform.tfstate"
    region = "us-east-1"
  }
}

# Recuperar o ID da Subnet 1 do Parameter Store
data "aws_ssm_parameter" "vpc_id" {
  name = "/rds/vpc"
}

# Recuperar o ID da Subnet 1 do Parameter Store
data "aws_ssm_parameter" "subnet_1" {
  name = "/rds/subnet_1"
}

# Recuperar o ID da Subnet 2 do Parameter Store
data "aws_ssm_parameter" "subnet_2" {
  name = "/rds/subnet_2"
}

# Recuperar o ID da Subnet 3 do Parameter Store
data "aws_ssm_parameter" "subnet_3" {
  name = "/rds/subnet_3"
}

# Criar o Security Group
resource "aws_security_group" "rds_sg" {
  vpc_id = data.aws_ssm_parameter.vpc_id.value

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
  subnet_ids = [
    data.aws_ssm_parameter.subnet_1.value,
    data.aws_ssm_parameter.subnet_2.value,
    data.aws_ssm_parameter.subnet_3.value
  ]

  tags = {
    Name = "rds-subnet-group"
  }
}

# Criar o banco de dados RDS PostgreSQL
resource "aws_db_instance" "payments_db" {
  identifier              = "payments-db"
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "13.14"
  instance_class          = "db.t3.micro"
  db_name                 = var.payments_db_name
  username                = var.payments_db_username
  password                = var.payments_db_password
  parameter_group_name    = "default.postgres13"
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
}