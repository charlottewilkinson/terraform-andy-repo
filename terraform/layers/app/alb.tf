resource "aws_security_group" "my_sg" {
  name   = "my-sg"
  vpc_id = data.aws_vpc.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "ingress_http" {
  security_group_id = aws_security_group.my_sg.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
  description       = "HTTP web traffic"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_https" {
  security_group_id = aws_security_group.my_sg.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  description       = "HTTPS web traffic"
}

resource "aws_vpc_security_group_egress_rule" "egress_all" {
  security_group_id = aws_security_group.my_sg.id
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name = "${var.project_name}-${var.environment}-alb"
  vpc_id  = data.aws_vpc.vpc.id
  subnets = data.aws_subnets.public.ids

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "ex-instance"
      }
    }
  }

  target_groups = {
    ex-instance = {
      name_prefix      = "h1"
      protocol         = "HTTP"
      port             = 80
      target_type      = "instance"

      health_check = {
        path = "/"
        port = 80
        healthy_threshold = 6
        unhealthy_threshold = 2
        timeout = 2
        interval = 5
        matcher = "200"  # has to be HTTP 200 or fails
      }
    }
  }
}