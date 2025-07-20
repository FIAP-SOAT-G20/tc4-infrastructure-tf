output "repository_url" {
  description = "The URL of the ECR repository"
  value       = data.aws_ecr_repository.customer_service.repository_url
}

output "repository_name" {
  description = "The name of the ECR repository"
  value       = data.aws_ecr_repository.customer_service.name
}

output "repository_arn" {
  description = "The ARN of the ECR repository"
  value       = data.aws_ecr_repository.customer_service.arn
}