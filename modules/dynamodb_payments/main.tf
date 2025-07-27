terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# DynamoDB Table for Payment Service
resource "aws_dynamodb_table" "payment_service" {
  name           = "payments"
  billing_mode   = var.billing_mode
  read_capacity  = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "order_id"
    type = "S"
  }

  attribute {
    name = "status"
    type = "S"
  }

  # Global Secondary Index for order_id lookup
  global_secondary_index {
    name            = "order-id-index"
    hash_key        = "order_id"
    projection_type = "ALL"
    read_capacity   = var.billing_mode == "PROVISIONED" ? var.gsi_read_capacity : null
    write_capacity  = var.billing_mode == "PROVISIONED" ? var.gsi_write_capacity : null
  }

  # Global Secondary Index for status lookup
  global_secondary_index {
    name            = "status-index"
    hash_key        = "status"
    projection_type = "ALL"
    read_capacity   = var.billing_mode == "PROVISIONED" ? var.gsi_read_capacity : null
    write_capacity  = var.billing_mode == "PROVISIONED" ? var.gsi_write_capacity : null
  }

  # Enable point-in-time recovery
  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  # Server-side encryption
  server_side_encryption {
    enabled      = var.enable_encryption
    kms_key_arn  = var.kms_key_arn
  }

  # TTL configuration (if needed)
  dynamic "ttl" {
    for_each = var.ttl_attribute != "" ? [1] : []
    content {
      attribute_name = var.ttl_attribute
      enabled        = true
    }
  }

  tags = var.common_tags

  lifecycle {
    prevent_destroy = true
  }
}

# CloudWatch Log Group for DynamoDB operations (optional)
resource "aws_cloudwatch_log_group" "dynamodb_logs" {
  count             = var.enable_cloudwatch_logs ? 1 : 0
  name              = "/aws/dynamodb/${aws_dynamodb_table.payment_service.name}"
  retention_in_days = var.log_retention_days

  tags = var.common_tags
}