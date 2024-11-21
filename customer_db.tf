# vars
variable "customer_db_name" {
  description = "customer_db Nome do banco de dados"
  type        = string
  sensitive = true
}
variable "customer_db_username" {
  description = "customer_db Nome de usuário do banco de dados"
  type        = string
  sensitive = true
}
variable "customer_db_password" {
  description = "customer_db Senha do banco de dados"
  type        = string
  sensitive   = true
}

# rds
resource "aws_db_instance" "customer_db" {
  identifier              = "customer-db"
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "13.14"
  instance_class          = "db.t3.micro"
  db_name                 = var.customer_db_name
  username                = var.customer_db_username
  password                = var.customer_db_password
  parameter_group_name    = "default.postgres13"
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
}

# secrets manager
resource "aws_secretsmanager_secret" "customer_db_credentials" {
  name = "rds-customer-db-credentials"
}
resource "aws_secretsmanager_secret_version" "customer_db_credentials" {
  depends_on = [aws_db_instance.customer_db]
  secret_id     = aws_secretsmanager_secret.customer_db_credentials.id
  secret_string = jsonencode({
    customer_db_name   = var.customer_db_name
    customer_db_username  = var.customer_db_username
    customer_db_password  = var.customer_db_password
    customer_db_endpoint  = aws_db_instance.customer_db.endpoint
  })
}

# out
output "customer_db_endpoint" {
  description = "Endpoint do banco de dados RDS customer_db"
  value       = aws_db_instance.customer_db.endpoint
}
output "customer_db_credentials_secret_arn" {
  description = "ARN do segredo das credenciais do banco de dados customer_db"
  value       = aws_secretsmanager_secret.customer_db_credentials.arn
}