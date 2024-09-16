# Criar o segredo no Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  name = "rds-postgres-credentials"
}

# Armazenar as credenciais e o endpoint no Secrets Manager
resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    db_name   = var.db_name
    username  = var.db_username
    password  = var.db_password
    endpoint  = aws_db_instance.postgres.endpoint
  })
}