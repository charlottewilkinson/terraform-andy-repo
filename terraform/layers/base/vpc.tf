data "aws_availability_zones" "available" {
    state = "available"
}

locals {
  azs = data.aws_availability_zones.available.names
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "my-vpc"
    cidr = var.cidr


    azs = local.azs
    private_subnets = [for k, v in local.azs : cidrsubnet("10.0.0.0/16", 3, k)]
    # separate from private subnet 
    public_subnets = [for k, v in local.azs : cidrsubnet("10.0.0.0/16", 3, k + 4)]
  
    enable_nat_gateway = true
    single_nat_gateway = var.environment == "dev" ? true : false
    one_nat_gateway_per_az = var.environment == "dev" ? false : true

    tags = {
    Terraform = "true"
    Environment = var.environment
    }
}