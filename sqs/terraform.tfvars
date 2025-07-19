sqs_queues = {
  order_status_updated = {
    name                        = "order-status-updated"
    delay_seconds              = 0
    message_retention_seconds  = 345600
    visibility_timeout_seconds = 30
  }

  kitchen_status_updated = {
    name                        = "kitchen-status-updated"
    delay_seconds              = 0
    message_retention_seconds  = 345600
    visibility_timeout_seconds = 30
  }

  kitchen_payment_approved = {
    name                        = "kitchen-payment-approved"
    delay_seconds              = 0
    message_retention_seconds  = 345600
    visibility_timeout_seconds = 30
  }

  payment_approved = {
    name                        = "payment-approved"
    delay_seconds              = 0
    message_retention_seconds  = 345600
    visibility_timeout_seconds = 30
  }
}
