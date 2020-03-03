// 프로 바이더 설정
// 테라폼과 외부 서비스를 연결해주는 기능
provider "aws" {
    profile    = "aws_provider"
    region     = var.my_region
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
}

// VPC 가상 네트워크 설정
resource "aws_vpc" "CRBS-vpc" {
  cidr_block             = "172.16.0.0/16"
  enable_dns_hostnames   = true  //dns 호스트 네임 활성화
  enable_dns_support     = true
  instance_tenancy       = "default"
  tags = { Name="CRBS-vpc" }  //태그 달아줌
}

// 서브넷 설정
# 다음과 같이 2개의 AZ에 public, private subnet을 각각 1개씩 생성한다.
# ${aws_vpc.dev.id} 는 aws_vpc의 dev리소스로부터 id값을 가져와서 세팅한다.
# resource name은 {aws_subnet.public_1a.id} 와 같이 작성하기 쉽도록 underscore를 사용했다.
resource "aws_subnet" "CRBS-subnet-public-a" {
  vpc_id                    = aws_vpc.CRBS-vpc.id
  availability_zone         = var.my_az1
  cidr_block                = "172.16.1.0/24"
  map_public_ip_on_launch   = true
  tags = { Name = "CRBS-public-a" }
}

resource "aws_subnet" "CRBS-subnet-private-a" {
  vpc_id            = aws_vpc.CRBS-vpc.id
  availability_zone = var.my_az1
  cidr_block        = "172.16.3.0/24"
  map_public_ip_on_launch   = false
  tags = { Name = "CRBS-private-a" }
}

resource "aws_subnet" "CRBS-subnet-public-c" {
  vpc_id            = aws_vpc.CRBS-vpc.id
  availability_zone = var.my_az2
  cidr_block        = "172.16.2.0/24"
  map_public_ip_on_launch   = true
  tags = { Name = "CRBS-public-c" }
}

resource "aws_subnet" "CRBS-subnet-private-c" {
  vpc_id            = aws_vpc.CRBS-vpc.id
  availability_zone = var.my_az2
  cidr_block        = "172.16.4.0/24"
  map_public_ip_on_launch   = false
  tags = { Name = "CRBS-private-c" }
}

# dev VPC에서 사용할 IGW를 정의한다.
# IGW는 AZ에 무관하게 한개의 IGW를 공유해서 사용할 수 있다.
resource "aws_internet_gateway" "CRBS-igw" {
  vpc_id = aws_vpc.CRBS-vpc.id
  tags = { Name = "CRBS-igw" }
}

# 각각의 AZ의 NAT에서 사용할 EIP를 정의한다.
# vpc = true 항목은 EIP 생성 시 EIP의 scope를 VPC로 할지 classic으로 할지 물어봤던 옵션을 의미하는 것으로 추측된다.
resource "aws_eip" "CRBS-eip" {
  vpc = true
  depends_on     = [aws_internet_gateway.CRBS-igw]
  tags = { Name = "CRBS-eip" }
}

# NAT Gateway
resource "aws_nat_gateway" "CRBS-nat" {
  allocation_id = aws_eip.CRBS-eip.id
  subnet_id     = aws_subnet.CRBS-subnet-public-a.id
  depends_on        = [aws_internet_gateway.CRBS-igw]
  tags = { Name = "CRBS-nat" }
}

# NAT도 IGW처럼 한개를 공유해서 사용하는지, 아니면 AZ별로 각각 NAT를 생성해야 하나 의문이 생겼었는데
# NAT 게이트웨이 – Amazon Virtual Private Cloud 가이드 문서에 따르면
# 가용영역(AZ) 별로 NAT 게이트웨이를 사용해야 복수의 AZ를 사용하는 장점을 같이 가져갈 수 있음을 알 수 있다.
# dev_public

resource "aws_route_table" "CRBS-route_table-public" {
  vpc_id = aws_vpc.CRBS-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.CRBS-igw.id
  }
  tags = { Name = "CRBS-public" }
}

resource "aws_route_table_association" "CRBS-route_table_associationpublic-a" {
  subnet_id      = aws_subnet.CRBS-subnet-public-a.id
  route_table_id = aws_route_table.CRBS-route_table-public.id
}

resource "aws_route_table_association" "CRBS-route_table_associationpublic-c" {
  subnet_id      = aws_subnet.CRBS-subnet-public-c.id
  route_table_id = aws_route_table.CRBS-route_table-public.id
}

resource "aws_route_table" "CRBS-route_table-private" {
  vpc_id = aws_vpc.CRBS-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.CRBS-nat.id
  }
  tags = { Name = "CRBS-private" }
}

resource "aws_route_table_association" "CRBS-route_table_association-private-a" {
  subnet_id      = aws_subnet.CRBS-subnet-private-a.id
  route_table_id = aws_route_table.CRBS-route_table-private.id
}
resource "aws_route_table_association" "CRBS-route_table_association-private-c" {
  subnet_id      = aws_subnet.CRBS-subnet-private-c.id
  route_table_id = aws_route_table.CRBS-route_table-private.id
}


# acl
resource "aws_network_acl" "CRBS-acl-public" {
  vpc_id = aws_vpc.CRBS-vpc.id
  subnet_ids = [
    aws_subnet.CRBS-subnet-public-a.id,
    aws_subnet.CRBS-subnet-public-c.id
  ]
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8080
    to_port    = 8080
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  ingress {
    protocol   = "icmp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "-1"
    to_port    = "-1"
    icmp_type = -1
    icmp_code = -1
  }
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "172.16.3.0/24"
    from_port  = 22
    to_port    = 22
  }
  egress {
    protocol   = "tcp"
    rule_no    = 121
    action     = "allow"
    cidr_block = "172.16.4.0/24"
    from_port  = 22
    to_port    = 22
  }
  egress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8080
    to_port    = 8080
  }
  egress {
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 32768
    to_port    = 65535
  }
  egress {
    protocol   = "tcp"
    rule_no    = 150
    action     = "allow"
    cidr_block = "172.16.3.0/24"
    from_port  = 3306
    to_port    = 3306
  }
  egress {
    protocol   = "tcp"
    rule_no    = 151
    action     = "allow"
    cidr_block = "172.16.4.0/24"
    from_port  = 3306
    to_port    = 3306
  }
  egress {
    protocol   = "icmp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "-1"
    to_port    = "-1"
    icmp_type = -1
    icmp_code = -1
  }
  tags = { Name = "CRBS-public" }
}

resource "aws_network_acl" "CRBS-acl-private" {
  vpc_id = aws_vpc.CRBS-vpc.id
  subnet_ids = [
    aws_subnet.CRBS-subnet-private-a.id,
    aws_subnet.CRBS-subnet-private-c.id
  ]
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "172.16.0.0/16"
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "172.16.0.0/16"
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "172.16.0.0/16"
    from_port  = 3306
    to_port    = 3306
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "172.16.0.0/16"
    from_port  = 8080
    to_port    = 8080
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "172.16.0.0/16"
    from_port  = 1024
    to_port    = 65535
  }
  ingress {
    protocol   = "icmp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "-1"
    to_port    = "-1"
    icmp_type = -1
    icmp_code = -1
    # description = "for ping test"
  }
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  egress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "172.16.1.0/24"
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = "tcp"
    rule_no    = 131
    action     = "allow"
    cidr_block = "172.16.2.0/24"
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8080
    to_port    = 8080
  }
  egress {
    protocol   = "tcp"
    rule_no    = 150
    action     = "allow"
    cidr_block = "172.16.0.0/16"
    from_port  = 3306
    to_port    = 3306
  }
  egress {
    protocol   = "icmp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "-1"
    to_port    = "-1"
    icmp_type = -1
    icmp_code = -1
    # description = "for ping test"
  }
  tags = { Name = "CRBS-private" }
}

# 보안 그룹
resource "aws_security_group" "CRBS-security_group-public" {
  name        = "CRBS-public"
  description = "security_group for public"
  vpc_id      = aws_vpc.CRBS-vpc.id
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
    protocol   = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = "-1"
    to_port    = "-1"
    description = "for ping test"
  }
  tags = { Name = "CRBS-public" }
}

resource "aws_security_group" "CRBS-security_group-private" {
  name        = "CRBS-private"
  description = "security_group for private"
  vpc_id      = aws_vpc.CRBS-vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.1.0/24"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.16.2.0/24"]
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
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol   = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port  = "-1"
    to_port    = "-1"
    description = "for ping test"
  }
  tags = { Name = "CRBS-private" }
}

resource "aws_security_group_rule" "public-egress-MySQL" {
  type            = "egress"
  from_port       = 3306
  to_port         = 3306
  protocol        = "tcp"
  source_security_group_id = aws_security_group.CRBS-security_group-private.id
  security_group_id = aws_security_group.CRBS-security_group-public.id
}

resource "aws_security_group_rule" "private-ingress-HTTP" {
  type            = "ingress"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  source_security_group_id = aws_security_group.CRBS-security_group-public.id
  security_group_id = aws_security_group.CRBS-security_group-private.id
}

resource "aws_security_group_rule" "private-ingress-MySQL" {
  type            = "ingress"
  from_port       = 3306
  to_port         = 3306
  protocol        = "tcp"
  source_security_group_id = aws_security_group.CRBS-security_group-public.id
  security_group_id = aws_security_group.CRBS-security_group-private.id
}

resource "aws_security_group_rule" "private-ingress-HTTPS" {
  type            = "ingress"
  from_port       = 443
  to_port         = 443
  protocol        = "tcp"
  source_security_group_id = aws_security_group.CRBS-security_group-public.id
  security_group_id = aws_security_group.CRBS-security_group-private.id
}

resource "aws_security_group_rule" "private-egress-MySQL" {
  type            = "egress"
  from_port       = 3306
  to_port         = 3306
  protocol        = "tcp"
  source_security_group_id = aws_security_group.CRBS-security_group-public.id
  security_group_id = aws_security_group.CRBS-security_group-private.id
}

# ====================================================create server===================================================

# CRBS-public UI 인스턴스 설정
resource "aws_instance" "CRBS-public-a" {
  instance_type               = "t2.micro"
  ami                         = var.ui_ami_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.CRBS-security_group-public.id]
  subnet_id                   = aws_subnet.CRBS-subnet-public-a.id
  associate_public_ip_address = true
  tags = { Name="CRBS-public-a" }
}

resource "aws_instance" "CRBS-public-c" {
  instance_type             = "t2.micro"
  ami                     = var.ui_ami_id
  key_name                = var.key_name
  vpc_security_group_ids  = [aws_security_group.CRBS-security_group-public.id]
  subnet_id               = aws_subnet.CRBS-subnet-public-c.id
  associate_public_ip_address = true
  tags = { Name = "CRBS-public-c" }
}

# CRBS-public API 인스턴스 설정
resource "aws_instance" "CRBS-private-a" {
  instance_type               = "t2.micro"
  ami                         = var.api_ami_id
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.CRBS-security_group-private.id]
  subnet_id                   = aws_subnet.CRBS-subnet-private-a.id
  tags = { Name="CRBS-private-a" }
}

resource "aws_instance" "CRBS-private-c" {
  instance_type             = "t2.micro"
  ami                     = var.api_ami_id
  key_name                = var.key_name
  vpc_security_group_ids  = [aws_security_group.CRBS-security_group-private.id]
  subnet_id               = aws_subnet.CRBS-subnet-private-c.id
  tags = { Name = "CRBS-private-c" }
}

# External alb 설정
resource "aws_lb" "CRBS-external" {
  name            = "CRBS-external"
  internal        = false
  idle_timeout    = "300"
  load_balancer_type = "application"
  security_groups = [aws_security_group.CRBS-security_group-public.id]
  subnets = [aws_subnet.CRBS-subnet-public-a.id, aws_subnet.CRBS-subnet-public-c.id]
  enable_deletion_protection = false
  tags = { Name = "CRBS-external" }
}

# External alb target group 설정
resource "aws_lb_target_group" "CRBS-UI" {
  name     = "CRBS-UI"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.CRBS-vpc.id
  target_type = "instance"
  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    path                = var.target_group_path
    interval            = 10
    port                = 80
  }
  tags = { Name = "CRBS-UI" }
}

# External listener
resource "aws_lb_listener" "CRBS-UI-listener" {
  load_balancer_arn = aws_lb.CRBS-external.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.CRBS-UI.arn
  }
}

# alb에 UI instance 연결
resource "aws_alb_target_group_attachment" "CRBS-UI-a" {
  target_group_arn = aws_lb_target_group.CRBS-UI.arn
  target_id        = aws_instance.CRBS-public-a.id
  port             = 80
}
resource "aws_alb_target_group_attachment" "CRBS-UI-c" {
  target_group_arn = aws_lb_target_group.CRBS-UI.arn
  target_id        = aws_instance.CRBS-public-c.id
  port             = 80
}

# ========================================================

# Internal alb 설정
resource "aws_lb" "CRBS-internal" {
  name            = "CRBS-internal"
  internal        = true
  idle_timeout    = "300"
  load_balancer_type = "application"
  security_groups = [aws_security_group.CRBS-security_group-public.id]
  subnets = [aws_subnet.CRBS-subnet-private-a.id, aws_subnet.CRBS-subnet-private-c.id]
  enable_deletion_protection = false
  tags = { Name = "CRBS-internal" }
}

# Internal alb target group 설정
resource "aws_lb_target_group" "CRBS-API" {
  name     = "CRBS-API"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.CRBS-vpc.id
  target_type = "instance"
  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    path                = var.target_group_path
    interval            = 10
    port                = 80
  }
  tags = { Name = "CRBS-API" }
}

# Internal listener
resource "aws_lb_listener" "CRBS-API-listener" {
  load_balancer_arn = aws_lb.CRBS-internal.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.CRBS-API.arn
  }
}

# Internal alb에 API instance 연결
resource "aws_alb_target_group_attachment" "CRBS-API-a" {
  target_group_arn = aws_lb_target_group.CRBS-API.arn
  target_id        = aws_instance.CRBS-private-a.id
  port             = 80
}

resource "aws_alb_target_group_attachment" "CRBS-API-c" {
  target_group_arn = aws_lb_target_group.CRBS-API.arn
  target_id        = aws_instance.CRBS-private-c.id
  port             = 80
}


# ====================================================create RDS===================================================

resource "aws_db_subnet_group" "CRBS-rds-subnet-group" {
  name       = "crbs-rds-subnet-group"
  subnet_ids = [aws_subnet.CRBS-subnet-private-a.id, aws_subnet.CRBS-subnet-private-c.id]
  description = "RDS subnet group for CRBS"
  tags = { Name = "crbs-rds-subnet-group" }
}

resource "aws_db_instance" "CRBS-rds-instance" {
  identifier           = "crbs-rds-instance"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.26"
  instance_class       = "db.t2.micro"
  username             = var.db_username
  password             = var.db_password
  port              = var.db_port
  db_subnet_group_name = aws_db_subnet_group.CRBS-rds-subnet-group.name
  multi_az             = true
  vpc_security_group_ids = [aws_security_group.CRBS-security_group-private.id]
  # final_snapshot_identifier = "crbs-rds-instance"
  skip_final_snapshot = true
}
