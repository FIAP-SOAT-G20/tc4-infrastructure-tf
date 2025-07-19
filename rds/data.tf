data "terraform_remote_state" "k8s" {
  backend = "s3"
  config = {
    bucket = "fast-food-terraform-state-soat-g19-tc4"
    key    = "fiap/k8s/terraform.tfstate"
    region = "us-east-1"
  }
}
