resource "aws_sqs_queue" "queues" {
  for_each = var.sqs_queues

  name                       = each.value.name
  delay_seconds              = each.value.delay_seconds
  message_retention_seconds  = each.value.message_retention_seconds
  visibility_timeout_seconds = each.value.visibility_timeout_seconds

  fifo_queue                  = lookup(each.value, "fifo_queue", false)
  content_based_deduplication = lookup(each.value, "content_based_deduplication", false)

  tags = merge({
    Environment = var.environment
    Name        = each.value.name
  }, lookup(each.value, "tags", {}))
}
