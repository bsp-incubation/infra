# External alb 설정
resource "aws_lb" "CRBS-external" {
  name            = "CRBS-external"
  internal        = false
  idle_timeout    = "300"
  load_balancer_type = "application"
  security_groups = [aws_security_group.CRBS-external-security_group-public.id]
  subnets = [
    aws_subnet.CRBS-subnet-public-a.id,
    aws_subnet.CRBS-subnet-public-c.id
    ]

  enable_deletion_protection = false
  tags = { Name = "CRBS-external" }
}

# External alb target group 설정
resource "aws_lb_target_group" "CRBS-UI1" {
  name     = "CRBS-UI1"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"

  stickiness {
    type                = "lb_cookie"
    cookie_duration     = 600
    enabled             = "true"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    path                = var.target_group_external_path
    interval            = 5
    port                = 8080
  }
  tags = { Name = "CRBS-UI1" }
}

# External alb target group 설정
resource "aws_lb_target_group" "CRBS-UI2" {
  name     = "CRBS-UI2"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"

  stickiness {
    type                = "lb_cookie"
    cookie_duration     = 600
    enabled             = "true"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    path                = var.target_group_external_path
    interval            = 5
    port                = 8080
  }
  tags = { Name = "CRBS-UI2" }
}

