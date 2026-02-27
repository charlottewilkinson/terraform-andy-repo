resource "aws_security_group" "primary_sg" {
  name   = "${var.project_name}-${var.environment}-sg"
  vpc_id = data.aws_vpc.vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "ingress_http" {
  security_group_id = aws_security_group.primary_sg.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
  description       = "HTTP web traffic"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_https" {
  security_group_id = aws_security_group.primary_sg.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  description       = "HTTPS web traffic"
}

resource "aws_vpc_security_group_egress_rule" "egress_all" {
  security_group_id = aws_security_group.primary_sg.id
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

module "primary_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name            = "${var.project_name}-${var.environment}-primary-alb"
  vpc_id          = data.aws_vpc.vpc.id
  subnets         = data.aws_subnets.public.ids
  security_groups = [aws_security_group.primary_sg.id]

  load_balancer_type    = "application"
  create_security_group = false
  # enable_deletion_protection = false

  target_groups = {
    app = {
      name_prefix = "h1"
      protocol    = "HTTP"
      port        = 80
      target_type = "instance"
      create_attachment = false

      health_check = {
        path                = "/"
        port                = 80
        unhealthy_threshold = 2
        interval            = 10
        timeout             = 5
        matcher             = "200"
      }
    }
  }

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "app"
      }
    }
  }
}