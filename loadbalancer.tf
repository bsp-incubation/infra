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
  vpc_id   = aws_vpc.CRBS-vpc.id
  target_type = "instance"

  stickiness {
    type                = "lb_cookie"
    cookie_duration     = 600
    enabled             = "false"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    path                = var.target_group_external_path
    interval            = 10
    port                = 8080
  }
  tags = { Name = "CRBS-UI1" }
}

# External alb target group 설정
resource "aws_lb_target_group" "CRBS-UI2" {
  name     = "CRBS-UI2"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.CRBS-vpc.id
  target_type = "instance"

  stickiness {
    type                = "lb_cookie"
    cookie_duration     = 600
    enabled             = "false"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    path                = var.target_group_external_path
    interval            = 10
    port                = 8080
  }
  tags = { Name = "CRBS-UI2" }
}

# External listener
# resource "aws_lb_listener" "CRBS-UI-listener" {
#   load_balancer_arn = aws_lb.CRBS-external.arn
#   port              = "8080"
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.CRBS-UI.arn
#   }
# }

# ========================================================

# Internal alb 설정
resource "aws_lb" "CRBS-internal" {
  name            = "CRBS-internal"
  internal        = true
  idle_timeout    = "300"
  load_balancer_type = "application"
  security_groups = [aws_security_group.CRBS-security_group-public.id]
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
  vpc_id   = aws_vpc.CRBS-vpc.id
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
  vpc_id   = aws_vpc.CRBS-vpc.id
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

# Internal listener
# resource "aws_lb_listener" "CRBS-API-listener" {
#   load_balancer_arn = aws_lb.CRBS-internal.arn
#   port              = "8090"
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.CRBS-API.arn
#   }
# }