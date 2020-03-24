# Internal alb 설정
resource "aws_lb" "CRBS-internal" {
  name            = "CRBS-internal"
  internal        = true
  idle_timeout    = "300"
  load_balancer_type = "application"
  security_groups = [var.CRBS-security_group-public]
  subnets = [
    aws_subnet.CRBS-subnet-private-a.id, 
    aws_subnet.CRBS-subnet-private-c.id
    ]
    
  enable_deletion_protection = false
  tags = { Name = "CRBS-internal" }
}

# Internal alb target group 설정
resource "aws_lb_target_group" "CRBS-API1" {
  name     = "CRBS-API1"
  port     = 8090
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"
  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    path                = var.target_group_internal_path
    interval            = 10
    port                = 8090
  }
  tags = { Name = "CRBS-API1" }
}

resource "aws_lb_target_group" "CRBS-API2" {
  name     = "CRBS-API2"
  port     = 8090
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "instance"
  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    path                = var.target_group_internal_path
    interval            = 10
    port                = 8090
  }
  tags = { Name = "CRBS-API2" }
}

