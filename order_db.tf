# vars
variable "order_db_name" {
  description = "order_db Nome do banco de dados"
  type        = string
  sensitive = true
}
variable "order_db_username" {
  description = "order_db Nome de usuário do banco de dados"
  type        = string
  sensitive = true
}
variable "order_db_password" {
  description = "order_db Senha do banco de dados"
  type        = string
  sensitive   = true
}

# rds
resource "aws_db_instance" "order_db" {
  identifier              = "order-db"
  allocated_storage       = 20
  engine                  = "postgres"
  engine_version          = "13.14"
  instance_class          = "db.t3.micro"
  db_name                 = var.order_db_name
  username                = var.order_db_username
  password                = var.order_db_password
  parameter_group_name    = "default.postgres13"
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
}

# secrets manager
resource "aws_secretsmanager_secret" "order_db_credentials" {
  name = "rds-order-db-credentials"
}
resource "aws_secretsmanager_secret_version" "order_db_credentials" {
  depends_on = [aws_db_instance.order_db]
  secret_id     = aws_secretsmanager_secret.order_db_credentials.id
  secret_string = jsonencode({
    order_db_name   = var.order_db_name
    order_db_username  = var.order_db_username
    order_db_password  = var.order_db_password
    order_db_endpoint  = aws_db_instance.order_db.endpoint
  })
}

# out
output "order_db_endpoint" {
  description = "Endpoint do banco de dados RDS order_db"
  value       = aws_db_instance.order_db.endpoint
}
output "order_db_credentials_secret_arn" {
  description = "ARN do segredo das credenciais do banco de dados order_db"
  value       = aws_secretsmanager_secret.order_db_credentials.arn
}