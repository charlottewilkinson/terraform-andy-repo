data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = ["${var.project_name}-${var.environment}-vpc"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name = "tag:Name"
    values = ["${var.project_name}-${var.environment}-vpc-public-*"]
  }
}