output "db_endpoint" {
  description = "Endpoint do banco de dados RDS"
  value       = aws_db_instance.postgres.endpoint
}

output "db_credentials_secret_arn" {
  description = "ARN do segredo das credenciais do banco de dados"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "security_group_id" {
  description = "ID do Security Group"
  value       = aws_security_group.rds_sg.id
}