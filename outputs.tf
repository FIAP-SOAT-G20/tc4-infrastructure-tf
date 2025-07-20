# EKS Outputs
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks_instance.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = module.eks_instance.cluster_endpoint
}

output "cluster_ca_certificate" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks_instance.cluster_ca_certificate
}

output "cluster_token" {
  description = "Token for EKS cluster authentication"
  value       = module.eks_instance.cluster_token
  sensitive   = true
}

# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.eks_instance.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.eks_instance.vpc_cidr
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = module.eks_instance.subnet_ids
}

# RDS Outputs
output "rds_postgres_kitchen_endpoint" {
  description = "DNS endpoint of the kitchen RDS instance"
  value       = module.rds_instance.rds_postgres_kitchen_endpoint
}

output "rds_postgres_kitchen_db_name" {
  description = "Database name of the kitchen RDS instance"
  value       = module.rds_instance.rds_postgres_kitchen_db_name
}

output "rds_postgres_order_endpoint" {
  description = "DNS endpoint of the order RDS instance"
  value       = module.rds_instance.rds_postgres_order_endpoint
}

output "rds_postgres_order_db_name" {
  description = "Database name of the order RDS instance"
  value       = module.rds_instance.rds_postgres_order_db_name
}

output "rds_username" {
  description = "Shared username for the RDS instances"
  value       = module.rds_instance.rds_username
}

# SNS Outputs
output "sns_topic_arn" {
  description = "ARN of the created SNS topic"
  value       = module.sns_instance.sns_topic_arn
}

output "sns_topic_name" {
  description = "Name of the created SNS topic"
  value       = module.sns_instance.sns_topic_name
}

# SQS Outputs
output "sqs_queue_urls" {
  description = "Map of SQS queue names to their URLs"
  value       = module.sqs_instance.sqs_queue_urls
}

output "sqs_queue_arns" {
  description = "Map of SQS queue names to their ARNs"
  value       = module.sqs_instance.sqs_queue_arns
}

# Customer Service Outputs
# API Gateway Outputs
output "customer_api_gateway_url" {
  description = "URL of the Customer Service API Gateway"
  value       = module.api_gateway.api_gateway_url
}

output "customer_api_gateway_id" {
  description = "ID of the Customer Service API Gateway"
  value       = module.api_gateway.api_gateway_id
}

# Lambda Outputs
output "customer_lambda_function_name" {
  description = "Name of the Customer Service Lambda function"
  value       = module.lambda.lambda_function_name
}

output "customer_lambda_function_arn" {
  description = "ARN of the Customer Service Lambda function"
  value       = module.lambda.lambda_arn
}

# MongoDB Atlas Outputs
output "mongodb_connection_string" {
  description = "MongoDB Atlas connection string"
  value       = module.mongodb_atlas.connection_string
  sensitive   = true
}

output "mongodb_cluster_name" {
  description = "MongoDB Atlas cluster name"
  value       = module.mongodb_atlas.cluster_name
}

# ECR Outputs
output "customer_ecr_repository_url" {
  description = "URL of the Customer Service ECR repository"
  value       = module.ecr.repository_url
}

# Application Endpoints
output "customer_api_endpoints" {
  description = "Customer API endpoints"
  value = {
    base_url       = module.api_gateway.api_gateway_url
    auth           = "${module.api_gateway.api_gateway_url}/auth"
    customers      = "${module.api_gateway.api_gateway_url}/customers"
    customer_by_id = "${module.api_gateway.api_gateway_url}/customers/{id}"
  }
}