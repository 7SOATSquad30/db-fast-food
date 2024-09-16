variable "aws_region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block da VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_1_cidr" {
  description = "CIDR block da primeira Subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_2_cidr" {
  description = "CIDR block da segunda Subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone_1" {
  description = "Zona de disponibilidade para a primeira Subnet"
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_2" {
  description = "Zona de disponibilidade para a segunda Subnet"
  type        = string
  default     = "us-east-1b"
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

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  sensitive = true
}

variable "db_username" {
  description = "Nome de usuário do banco de dados"
  type        = string
  sensitive = true
}

variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
  sensitive   = true
}