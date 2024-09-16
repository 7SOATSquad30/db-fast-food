output "db_endpoint" {
  description = "Endpoint do banco de dados RDS"
  value       = aws_db_instance.postgres.endpoint
}

output "db_credentials_secret_arn" {
  description = "ARN do segredo das credenciais do banco de dados"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.main.id
}

output "subnet_1_id" {
  description = "ID da primeira Subnet"
  value       = aws_subnet.subnet_1.id
}

output "subnet_2_id" {
  description = "ID da segunda Subnet"
  value       = aws_subnet.subnet_2.id
}

output "security_group_id" {
  description = "ID do Security Group"
  value       = aws_security_group.rds_sg.id
}