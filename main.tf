terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "~> 1.15"
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

provider "mongodbatlas" {
  public_key  = var.mongodb_atlas_public_key
  private_key = var.mongodb_atlas_private_key
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

# MongoDB Atlas Cluster
module "mongodb_atlas" {
  source = "./modules/mongodb_atlas"

  project_name        = var.customer_project_name
  environment         = var.environment
  mongodb_org_id      = var.mongodb_atlas_org_id
  mongodb_version     = var.mongodb_version
  cluster_tier        = var.mongodb_cluster_tier
  region              = var.mongodb_region
  mongodb_username    = var.mongodb_username
  mongodb_password    = var.mongodb_password
  allowed_cidr_blocks = var.mongodb_allowed_cidr_blocks
  common_tags         = var.common_tags
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
    ENVIRONMENT      = var.environment
    MONGODB_URI      = module.mongodb_atlas.connection_string
    MONGODB_DATABASE = "customer_service"
    JWT_SECRET       = var.jwt_secret
    LOG_LEVEL        = var.log_level
  }

  depends_on = [module.mongodb_atlas]
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
