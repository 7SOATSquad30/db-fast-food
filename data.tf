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