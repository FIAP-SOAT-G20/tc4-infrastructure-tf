# ECR Repository - References existing repository created by GitHub Actions
data "aws_ecr_repository" "customer_service" {
  name = "${var.project_name}-${var.environment}"
}