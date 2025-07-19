variable "db_username" {
  type        = string
  description = "Master username for the PostgreSQL RDS instance"
}

variable "db_password" {
  type        = string
  description = "Master password for the PostgreSQL RDS instance"
  sensitive   = true
}

variable "region" {
  default = "us-east-1"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs where the RDS instances will be deployed"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the RDS instances will be deployed"
}
