# Armazenar o ID do Security Group no Parameter Store
resource "aws_ssm_parameter" "security_group" {
  name  = "/rds/security_group"
  type  = "String"
  value = aws_security_group.rds_sg.id
}

# Armazenar o nome do grupo de subnets no Parameter Store
resource "aws_ssm_parameter" "subnet_group" {
  name  = "/rds/subnet_group"
  type  = "String"
  value = aws_db_subnet_group.rds_subnet_group.name
}