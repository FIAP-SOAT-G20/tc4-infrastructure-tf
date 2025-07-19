output "rds_postgres_kitchen_endpoint" {
  description = "DNS endpoint of the kitchen RDS instance"
  value       = aws_db_instance.postgres_kitchen.address
}

output "rds_postgres_kitchen_db_name" {
  description = "Database name of the kitchen RDS instance"
  value       = aws_db_instance.postgres_kitchen.db_name
}

output "rds_postgres_order_endpoint" {
  description = "DNS endpoint of the order RDS instance"
  value       = aws_db_instance.postgres_order.address
}

output "rds_postgres_order_db_name" {
  description = "Database name of the order RDS instance"
  value       = aws_db_instance.postgres_order.db_name
}

output "rds_username" {
  description = "Shared username for the RDS instances"
  value       = var.db_username
}
