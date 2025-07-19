terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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
}

module "sns_instance" {
  source = "./modules/sns_instance"

  aws_region     = var.aws_region
  environment    = var.environment
  sns_topic_name = "payment-approved"
}

module "rds_instance" {
  source = "./modules/rds_instance"

  db_username = var.rds_db_username
  db_password = var.rds_db_password
  subnet_ids  = module.eks_instance.subnet_ids
  vpc_id      = module.eks_instance.vpc_id

  depends_on = [module.eks_instance]
}
