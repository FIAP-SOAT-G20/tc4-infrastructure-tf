terraform {
  backend "s3" {
    bucket = "fast-food-terraform-state-soat-g19-tc4"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
