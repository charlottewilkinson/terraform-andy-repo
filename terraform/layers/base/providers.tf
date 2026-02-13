terraform {
  required_version = "~> 1.14.4"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      Environment = "sandbox19"
      Project     = "lab1"
      Owner       = "charlotte"
      ManagedBy   = "terraform"
    }
  }
}