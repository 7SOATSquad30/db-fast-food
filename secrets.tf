# Criar o segredo no Secrets Manager
resource "aws_secretsmanager_secret" "payments_db_credentials" {
  name = "rds-payments-db-credentials"
}

# Armazenar as credenciais e o endpoint no Secrets Manager
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