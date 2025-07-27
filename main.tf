terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
     kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16"
    }
  }

  backend "s3" {
    bucket = "fast-food-terraform-state-soat-g19-tc4"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.common_tags
  }
}


module "eks_instance" {
  source = "./modules/eks_instance"
}

module "sqs_instance" {
  source = "./modules/sqs_instance"

  aws_region  = var.aws_region
  environment = var.environment
  sqs_queues  = var.sqs_queues

  depends_on = [module.eks_instance]
}

module "sns_instance" {
  source = "./modules/sns_instance"

  aws_region     = var.aws_region
  environment    = var.environment
  sns_topic_name = "payment-approved"

  depends_on = [module.eks_instance]
}

module "rds_instance" {
  source = "./modules/rds_instance"

  aws_region  = var.aws_region
  environment = var.environment
  db_username = var.rds_db_username
  db_password = var.rds_db_password
  subnet_ids  = module.eks_instance.subnet_ids
  vpc_id      = module.eks_instance.vpc_id

  depends_on = [module.eks_instance]
}

# Customer Service Components (Lambda-based)
# ECR Repository
module "ecr" {
  source = "./modules/ecr"

  project_name = var.customer_project_name
  environment  = var.environment
  common_tags  = var.common_tags
}

# DynamoDB Table
module "dynamodb" {
  source = "./modules/dynamodb"

  project_name                 = var.customer_project_name
  environment                  = var.environment
  billing_mode                 = var.dynamodb_billing_mode
  read_capacity               = var.dynamodb_read_capacity
  write_capacity              = var.dynamodb_write_capacity
  gsi_read_capacity           = var.dynamodb_gsi_read_capacity
  gsi_write_capacity          = var.dynamodb_gsi_write_capacity
  enable_point_in_time_recovery = var.dynamodb_enable_pitr
  enable_encryption           = var.dynamodb_enable_encryption
  common_tags                 = var.common_tags
}

# Lambda Function
module "lambda" {
  source = "./modules/lambda"

  project_name     = var.customer_project_name
  environment      = var.environment
  lambda_image_uri = "${module.ecr.repository_url}:latest"
  lambda_memory    = var.lambda_memory
  lambda_timeout   = var.lambda_timeout
  common_tags      = var.common_tags

  environment_variables = {
    ENVIRONMENT           = var.environment
    DYNAMODB_TABLE_NAME   = module.dynamodb.table_name
    DYNAMODB_REGION       = var.aws_region
    JWT_SECRET            = var.jwt_secret
    LOG_LEVEL             = var.log_level
  }

  depends_on = [module.dynamodb]
}

# API Gateway
module "api_gateway" {
  source = "./modules/api_gateway"

  project_name      = var.customer_project_name
  environment       = var.environment
  lambda_arn        = module.lambda.lambda_arn
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
  common_tags       = var.common_tags

  depends_on = [module.lambda]
}

# Lambda Permission for API Gateway
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.api_gateway.api_gateway_execution_arn}/*/*"

  depends_on = [module.lambda, module.api_gateway]
}
