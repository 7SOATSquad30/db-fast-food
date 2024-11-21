variable "aws_region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-1"
}

variable "allowed_cidr" {
  description = "CIDR block permitido para acessar o banco de dados"
  type        = string
  default     = "0.0.0.0/0"
}

variable "subnet_group_name" {
  description = "Nome do grupo de subnets"
  type        = string
  default     = "rds-subnet-group"
}

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