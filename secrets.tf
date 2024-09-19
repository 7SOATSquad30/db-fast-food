# Criar o segredo no Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  name = "rds-postgres-credentials_v6"
}

# Armazenar as credenciais e o endpoint no Secrets Manager
resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    db_name   = var.db_name
    db_username  = var.db_username
    db_password  = var.db_password
    db_endpoint  = aws_db_instance.postgres.endpoint
  })
}