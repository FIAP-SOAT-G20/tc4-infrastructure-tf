output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.customer_service.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.customer_service.arn
}

output "table_id" {
  description = "ID of the DynamoDB table"
  value       = aws_dynamodb_table.customer_service.id
}

output "gsi_name" {
  description = "Name of the Global Secondary Index for CPF"
  value       = "cpf-index"
}

output "table_stream_arn" {
  description = "ARN of the DynamoDB table stream (if enabled)"
  value       = aws_dynamodb_table.customer_service.stream_arn
}