output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.payment_service.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.payment_service.arn
}

output "table_id" {
  description = "ID of the DynamoDB table"
  value       = aws_dynamodb_table.payment_service.id
}

output "order_id_gsi_name" {
  description = "Name of the Global Secondary Index for order_id"
  value       = "order-id-index"
}

output "status_gsi_name" {
  description = "Name of the Global Secondary Index for status"
  value       = "status-index"
}

output "table_stream_arn" {
  description = "ARN of the DynamoDB table stream (if enabled)"
  value       = aws_dynamodb_table.payment_service.stream_arn
}