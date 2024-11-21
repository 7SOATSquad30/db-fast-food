# vars
variable "payments_db_name" {
  description = "payments_db Nome do banco de dados"
  type        = string
  sensitive = true
}
variable "payments_db_username" {
  description = "payments_db Nome de usuário do banco de dados"
  type        = string
  sensitive = true
}
variable "payments_db_password" {
  description = "payments_db Senha do banco de dados"
  type        = string
  sensitive   = true
}

# rds
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

# secrets manager
resource "aws_secretsmanager_secret" "payments_db_credentials" {
  name = "rds-payments-db-credentials"
}
resource "aws_secretsmanager_secret_version" "payments_db_credentials" {
  depends_on = [aws_db_instance.payments_db]
  secret_id     = aws_secretsmanager_secret.payments_db_credentials.id
  secret_string = jsonencode({
    payments_db_name   = var.payments_db_name
    payments_db_username  = var.payments_db_username
    payments_db_password  = var.payments_db_password
    payments_db_endpoint  = aws_db_instance.payments_db.endpoint
  })
}

# out
output "payments_db_endpoint" {
  description = "Endpoint do banco de dados RDS payments_db"
  value       = aws_db_instance.payments_db.endpoint
}
output "payments_db_credentials_secret_arn" {
  description = "ARN do segredo das credenciais do banco de dados payments_db"
  value       = aws_secretsmanager_secret.payments_db_credentials.arn
}