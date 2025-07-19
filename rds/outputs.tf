output "rds_endpoint" {
  description = "DNS endpoint do RDS"
  value       = aws_db_instance.postgres.address
}

output "rds_username" {
  value = var.db_username
}

output "rds_db_name" {
  value = aws_db_instance.postgres.db_name
}
