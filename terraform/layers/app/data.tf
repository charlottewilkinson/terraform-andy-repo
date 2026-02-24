data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = "${var.project_name}-${var.environment}-vpc"
  }
}

