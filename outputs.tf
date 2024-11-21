output "payments_db_endpoint" {
  description = "Endpoint do banco de dados RDS payments_db"
  value       = aws_db_instance.payments_db.endpoint
}

output "payments_db_credentials_secret_arn" {
  description = "ARN do segredo das credenciais do banco de dados payments_db"
  value       = aws_secretsmanager_secret.payments_db_credentials.arn
}

output "security_group_id" {
  description = "ID do Security Group"
  value       = aws_security_group.rds_sg.id
}