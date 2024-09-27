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

# Outputs para verificar os valores recuperados
output "subnet_1_id" {
  value = data.aws_ssm_parameter.subnet_1.value
}

output "subnet_2_id" {
  value = data.aws_ssm_parameter.subnet_2.value
}

output "subnet_3_id" {
  value = data.aws_ssm_parameter.subnet_3.value
}