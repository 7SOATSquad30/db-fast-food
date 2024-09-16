# Armazenar o ID da VPC no Parameter Store
resource "aws_ssm_parameter" "vpc" {
  name  = "/rds/vpc"
  type  = "String"
  value = aws_vpc.main.id
}

# Armazenar o ID do Security Group no Parameter Store
resource "aws_ssm_parameter" "security_group" {
  name  = "/rds/security_group"
  type  = "String"
  value = aws_security_group.rds_sg.id
}

# Armazenar os IDs das Subnets no Parameter Store
resource "aws_ssm_parameter" "subnet_1" {
  name  = "/rds/subnet_1"
  type  = "String"
  value = aws_subnet.subnet_1.id
}

resource "aws_ssm_parameter" "subnet_2" {
  name  = "/rds/subnet_2"
  type  = "String"
  value = aws_subnet.subnet_2.id
}

# Armazenar o nome do grupo de subnets no Parameter Store
resource "aws_ssm_parameter" "subnet_group" {
  name  = "/rds/subnet_group"
  type  = "String"
  value = aws_db_subnet_group.rds_subnet_group.name
}