terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket = "some_example_bucket"
    key    = "example.terraform.tfstate"
    encrypt = true
  }
  required_version = ">= 1.5.1"
}