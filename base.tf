# vars
variable "aws_region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-1"
}
variable "allowed_cidr" {
  description = "CIDR block permitido para acessar o banco de dados"
  type        = string
  default     = "0.0.0.0/0"
}
variable "subnet_group_name" {
  description = "Nome do grupo de subnets"
  type        = string
  default     = "rds-subnet-group"
}

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

# param store
resource "aws_ssm_parameter" "security_group" {
  name  = "/rds/security_group"
  type  = "String"
  value = aws_security_group.rds_sg.id
}
resource "aws_ssm_parameter" "subnet_group" {
  name  = "/rds/subnet_group"
  type  = "String"
  value = aws_db_subnet_group.rds_subnet_group.name
}

# out
output "security_group_id" {
  description = "ID do Security Group"
  value       = aws_security_group.rds_sg.id
}
