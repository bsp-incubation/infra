# 보안 그룹
resource "aws_security_group" "CRBS-security_group-public" {
  name        = "CRBS-security_group-public"
  description = "security_group for public"
  vpc_id      = var.vpc_id
  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidr_blocks = ["172.16.0.0/16"]
  }
  ingress {
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080
    cidr_blocks = ["172.16.0.0/16"]
  }
  ingress {
    protocol  = "tcp"
    from_port = 8090
    to_port   = 8090
    cidr_blocks = ["172.16.0.0/16"]
  }
  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["172.16.0.0/16"]
  }
  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidr_blocks = ["172.16.0.0/16"]
  }
  ingress {
    protocol  = "tcp"
    from_port = 3000
    to_port   = 3000
    cidr_blocks = ["172.16.0.0/16"]
  }
  ingress {
    protocol   = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = "-1"
    to_port    = "-1"
    description = "for ping test"
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 8090
    to_port     = 8090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/16"]
  }
  egress {
    protocol   = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = "-1"
    to_port    = "-1"
    description = "for ping test"
  }
  tags = { Name = "CRBS-security_group-public" }
}


# load_balancer-security_group
resource "aws_security_group" "CRBS-external-security_group-public" {
  name        = "CRBS-external-load_balancer"
  description = "security_group for load_balancer"
  vpc_id = var.vpc_id
  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol  = "tcp"
    from_port = 3000
    to_port   = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol  = "tcp"
    from_port = 8090
    to_port   = 8090
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 8090
    to_port     = 8090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "CRBS-external-load_balancer"
  }
}