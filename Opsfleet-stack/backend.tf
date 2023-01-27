terraform {
  backend "s3" {
    bucket = "opsfleet-stack-s3-state-bucket"
    key    = "terraform/opsfleet-stack/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}