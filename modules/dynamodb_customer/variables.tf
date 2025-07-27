variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "billing_mode" {
  description = "DynamoDB billing mode (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "read_capacity" {
  description = "Read capacity units for the table (only used with PROVISIONED billing mode)"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Write capacity units for the table (only used with PROVISIONED billing mode)"
  type        = number
  default     = 5
}

variable "gsi_read_capacity" {
  description = "Read capacity units for GSI (only used with PROVISIONED billing mode)"
  type        = number
  default     = 5
}

variable "gsi_write_capacity" {
  description = "Write capacity units for GSI (only used with PROVISIONED billing mode)"
  type        = number
  default     = 5
}

variable "enable_point_in_time_recovery" {
  description = "Enable point-in-time recovery for DynamoDB table"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable server-side encryption for DynamoDB table"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID for encryption (optional)"
  type        = string
  default     = null
}

variable "ttl_attribute" {
  description = "TTL attribute name (optional)"
  type        = string
  default     = ""
}

variable "enable_cloudwatch_logs" {
  description = "Enable CloudWatch logs for DynamoDB"
  type        = bool
  default     = false
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}