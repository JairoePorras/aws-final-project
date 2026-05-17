output "alb_dns_name" {
  description = "DNS publico del Application Load Balancer"
  value       = aws_lb.app.dns_name
}

output "health_url" {
  description = "Endpoint de validacion del servicio"
  value       = "http://${aws_lb.app.dns_name}/health"
}

output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.main.id
}

output "rds_primary_endpoint" {
  description = "Endpoint privado de RDS primario"
  value       = aws_db_instance.primary.address
}

output "rds_replica_endpoint" {
  description = "Endpoint privado de la replica RDS"
  value       = try(aws_db_instance.replica[0].address, "replica_disabled")
}
