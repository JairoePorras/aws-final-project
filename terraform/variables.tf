variable "aws_region" {
  description = "Region de AWS donde se desplegara la infraestructura"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre base del proyecto"
  type        = string
  default     = "dgiti-final"
}

variable "vpc_cidr" {
  description = "CIDR principal de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "app_port" {
  description = "Puerto interno de la aplicacion"
  type        = number
  default     = 3000
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Usuario administrador de RDS"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password administrador de RDS. Cambiar en terraform.tfvars"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Clase de instancia RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "create_read_replica" {
  description = "Crear replica de lectura RDS"
  type        = bool
  default     = true
}

variable "allowed_http_cidr" {
  description = "CIDR autorizado para entrar al ALB por HTTP"
  type        = string
  default     = "0.0.0.0/0"
}
