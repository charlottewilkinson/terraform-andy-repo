terraform {
  required_version = "~> 1.5.5"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      CreatedBy   = "Terraform"
    }
  }
}