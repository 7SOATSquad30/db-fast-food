# vars
variable "products_db_name" {
  description = "products_db Nome do banco de dados"
  type        = string
  sensitive = true
}
variable "products_db_username" {
  description = "products_db Nome de usuário do banco de dados"
  type        = string
  sensitive = true
}
variable "products_db_password" {
  description = "products_db Senha do banco de dados"
  type        = string
  sensitive   = true
}

# rds
resource "aws_db_instance" "products_db" {
  identifier              = "products-db"
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "13.14"
  instance_class          = "db.t3.micro"
  db_name                 = var.products_db_name
  username                = var.products_db_username
  password                = var.products_db_password
  parameter_group_name    = "default.postgres13"
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
}

# secrets manager
resource "aws_secretsmanager_secret" "products_db_credentials" {
  name = "rds-products-db-credentials"
}
resource "aws_secretsmanager_secret_version" "products_db_credentials" {
  depends_on = [aws_db_instance.products_db]
  secret_id     = aws_secretsmanager_secret.products_db_credentials.id
  secret_string = jsonencode({
    products_db_name   = var.products_db_name
    products_db_username  = var.products_db_username
    products_db_password  = var.products_db_password
    products_db_endpoint  = aws_db_instance.products_db.endpoint
  })
}

# out
output "products_db_endpoint" {
  description = "Endpoint do banco de dados RDS products_db"
  value       = aws_db_instance.products_db.endpoint
}
output "products_db_credentials_secret_arn" {
  description = "ARN do segredo das credenciais do banco de dados products_db"
  value       = aws_secretsmanager_secret.products_db_credentials.arn
}