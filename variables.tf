# General Variables
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "tc4"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
  default = "dev"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project   = "TC4"
    Terraform = "true"
  }
}

variable "log_level" {
  description = "Log level"
  type        = string
  default     = "INFO"
  validation {
    condition     = contains(["DEBUG", "INFO", "WARN", "ERROR"], var.log_level)
    error_message = "Log level must be one of: DEBUG, INFO, WARN, ERROR."
  }
}

variable "rds_db_username" {
  description = "Master username for the PostgreSQL RDS instances"
  type        = string
  default     = "postgres"
}

variable "rds_db_password" {
  description = "Master password for the PostgreSQL RDS instances"
  type        = string
  sensitive   = true
  default    = "postgres"
}

variable "sqs_queues" {
  description = "Map of SQS queue configurations"
  type = map(object({
    name                        = string
    delay_seconds               = number
    message_retention_seconds   = number
    visibility_timeout_seconds  = number
    fifo_queue                  = optional(bool)
    content_based_deduplication = optional(bool)
    tags                        = optional(map(string))
  }))
  default = {
    "order_queue" = {
      name                        = "order-status-updated"
      delay_seconds               = 0
      message_retention_seconds   = 1209600 # 14 days
      visibility_timeout_seconds  = 60
      fifo_queue                  = false
      content_based_deduplication = false
      tags = {
        Purpose = "Order Notifications"
      }
    }
    "kitchen_queue" = {
      name                        = "kitchen-status-updated"
      delay_seconds               = 0
      message_retention_seconds   = 1209600 # 14 days
      visibility_timeout_seconds  = 60
      fifo_queue                  = false
      content_based_deduplication = false
      tags = {
        Purpose = "Kitchen Notifications"
      }
    }
  }
}
