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

# VPC peering 설정
resource "aws_vpc_peering_connection" "CRBS-vpc-peering" {
  peer_vpc_id   = "vpc-3a61a851"
  vpc_id        = "${aws_vpc.CRBS-vpc.id}"
  tags = { Name="CRBS-vpc-peering" }  //태그 달아줌
}

# Accepter's side of the connection
resource "aws_vpc_peering_connection_accepter" "CRBS-vpc-peering-accepter" {
  vpc_peering_connection_id = "${aws_vpc_peering_connection.CRBS-vpc-peering.id}"
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
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

resource "aws_subnet" "CRBS-subnet-public-2a" {
  vpc_id                    = aws_vpc.CRBS-vpc.id
  availability_zone         = var.my_az1
  cidr_block                = "172.16.5.0/24"
  map_public_ip_on_launch   = true
  tags = { Name = "CRBS-public-2a" }
}

resource "aws_subnet" "CRBS-subnet-private-2a" {
  vpc_id            = aws_vpc.CRBS-vpc.id
  availability_zone = var.my_az1
  cidr_block        = "172.16.6.0/24"
  map_public_ip_on_launch   = false
  tags = { Name = "CRBS-private-2a" }
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
resource "aws_nat_gateway" "CRBS-natgateway" {
  allocation_id = aws_eip.CRBS-eip.id
  subnet_id     = aws_subnet.CRBS-subnet-public-a.id
  depends_on        = [aws_internet_gateway.CRBS-igw]
  tags = { Name = "CRBS-natgateway" }
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

resource "aws_route_table_association" "CRBS-route_table_associationpublic-2a" {
  subnet_id      = aws_subnet.CRBS-subnet-public-2a.id
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
    nat_gateway_id = aws_nat_gateway.CRBS-natgateway.id
  }
  route {
    cidr_block     = "172.31.0.0/16"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.CRBS-vpc-peering.id}"
  }
  tags = { Name = "CRBS-private" }
}

resource "aws_route_table_association" "CRBS-route_table_association-private-a" {
  subnet_id      = aws_subnet.CRBS-subnet-private-a.id
  route_table_id = aws_route_table.CRBS-route_table-private.id
}

# vpc peering 대상 route table
resource "aws_route" "default_vpc_routing" {
  route_table_id            = "rtb-3b32a450"
  destination_cidr_block    = "172.16.0.0/16"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.CRBS-vpc-peering.id}"
}

resource "aws_route_table_association" "CRBS-route_table_association-private-2a" {
  subnet_id      = aws_subnet.CRBS-subnet-private-2a.id
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
    aws_subnet.CRBS-subnet-public-2a.id,
    aws_subnet.CRBS-subnet-public-c.id,
   aws_subnet.CRBS-subnet-private-a.id,
   aws_subnet.CRBS-subnet-private-2a.id,
    aws_subnet.CRBS-subnet-private-c.id
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
    rule_no    = 131
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8090
    to_port    = 8090
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
    rule_no    = 131
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8090
    to_port    = 8090
  }
  egress {
    protocol   = "tcp"
    rule_no    = 140
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
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


# 보안 그룹
resource "aws_security_group" "CRBS-security_group-public" {
  name        = "CRBS-public"
  description = "security_group for public"
  vpc_id      = aws_vpc.CRBS-vpc.id
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
    cidr_blocks = ["172.16.0.0/16"]
  }
  ingress {
    from_port   = 8090
    to_port     = 8090
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/16"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/16"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/16"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/16"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.31.33.134/32"]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
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
    from_port   = 443
    to_port     = 443
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
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/16"]
  }
  egress {
    from_port   = 3000
    to_port     = 3000
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
  tags = { Name = "CRBS-private" }
}


# =========================================================AMI=======================================================
data "aws_ami" "UI-ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["UI-ami*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["144149479695"]
}
data "aws_ami" "API-ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["API-ami*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["144149479695"]
}

# ================================================Load Balancer===================================================
# load_balancer-security_group
resource "aws_security_group" "CRBS-external-security_group-public" {
  name        = "CRBS-external-load_balancer"
  description = "security_group for load_balancer"
  vpc_id = "${aws_vpc.CRBS-vpc.id}"

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

  tags = {
    Name = "CRBS-external-load_balancer"
  }
}

# External alb 설정
resource "aws_lb" "CRBS-external" {
  name            = "CRBS-external"
  internal        = false
  idle_timeout    = "300"
  load_balancer_type = "application"
  security_groups = [aws_security_group.CRBS-external-security_group-public.id]

  subnets = [
    aws_subnet.CRBS-subnet-public-2a.id, 
    aws_subnet.CRBS-subnet-public-c.id
    ]
  enable_deletion_protection = false
  tags = { Name = "CRBS-external" }
}

# External alb target group 설정
resource "aws_lb_target_group" "CRBS-UI" {
  name     = "CRBS-UI"
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
  tags = { Name = "CRBS-UI" }
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
resource "aws_lb_listener" "CRBS-UI-listener" {
  load_balancer_arn = aws_lb.CRBS-external.arn
  port              = "8080"
  protocol          = "HTTP"
  default_action    = [{
    type             = "forward"
    target_group_arn = aws_lb_target_group.CRBS-UI.arn
  },
     {
    type             = "forward"
    target_group_arn = aws_lb_target_group.CRBS-UI2.arn
  } ]
}

# ========================================================

# Internal alb 설정
resource "aws_lb" "CRBS-internal" {
  name            = "CRBS-internal"
  internal        = true
  idle_timeout    = "300"
  load_balancer_type = "application"
  security_groups = [aws_security_group.CRBS-security_group-public.id]
  # subnets = [
  #   aws_subnet.CRBS-subnet-private-a.id, 
  #   aws_subnet.CRBS-subnet-private-c.id
  #   ]
    
  subnets = [
    aws_subnet.CRBS-subnet-private-2a.id, 
    aws_subnet.CRBS-subnet-private-c.id
    ]
  enable_deletion_protection = false
  tags = { Name = "CRBS-internal" }
}

# Internal alb target group 설정
resource "aws_lb_target_group" "CRBS-API" {
  name     = "CRBS-API"
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
  tags = { Name = "CRBS-API" }
}

# Internal listener
resource "aws_lb_listener" "CRBS-API-listener" {
  load_balancer_arn = aws_lb.CRBS-internal.arn
  port              = "8090"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.CRBS-API.arn
  }
}


# =================================================Instance Policy & Role======================================================
resource "aws_iam_role" "CRBS-instace_role" {
  name = "CRBS-instace_role"

  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow"
        }
      ]
    }
EOF
}

resource "aws_iam_policy" "CRBS-instace_policy" {
  name        = "CRBS-instace_policy"
  description = "CRBS-instace_policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "CRBS-instace_role_policy-attach" {
  role       = "${aws_iam_role.CRBS-instace_role.name}"
  policy_arn = "${aws_iam_policy.CRBS-instace_policy.arn}"
}

resource "aws_iam_instance_profile" "CRBS-instace_profile" {
  name = "CRBS-instace_profile"
  role = "${aws_iam_role.CRBS-instace_role.name}"
}

# =========================================================aws_launch_template========================================================= #

# # aws_launch_template
resource "aws_launch_template" "UI-template" {
  name = "UI_template"
  image_id = "${data.aws_ami.UI-ami.id}"
  instance_type = "t2.micro"
  key_name = var.key_name

  iam_instance_profile  {
    arn             = "${aws_iam_instance_profile.CRBS-instace_profile.arn}"
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = ["${aws_security_group.CRBS-security_group-public.id}"]
  }

  tag_specifications {
    resource_type = "instance"

  tags = {
      Name = "UI_template"
    }
  }
}

resource "aws_launch_template" "API-template" {
  name = "API_template"
  image_id = "${data.aws_ami.API-ami.id}"
  instance_type = "t2.micro"
  key_name = var.key_name

  iam_instance_profile  {
    arn             = "${aws_iam_instance_profile.CRBS-instace_profile.arn}"
  }

  network_interfaces {
    security_groups = ["${aws_security_group.CRBS-security_group-private.id}"]
  }

  tag_specifications {
    resource_type = "instance"

  tags = {
      Name = "API_template"
    }
  }
}

# =============================================autoscaling group=============================================

# ====================================데모 사항 new-UI autoscaling group=====================================
resource "aws_autoscaling_group" "UI-asg" {
  name               = "UI-asg"
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  # health_check_type         = "ELB"
  health_check_grace_period = 300

  vpc_zone_identifier       = [
    "${aws_subnet.CRBS-subnet-public-c.id}", 
    "${aws_subnet.CRBS-subnet-public-2a.id}"
    ]
  termination_policies      = ["default"]
  # target_group_arns  = ["${aws_lb_target_group.CRBS-UI.arn}"]
  launch_template {
    id      = "${aws_launch_template.UI-template.id}"
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "UI-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "UI-asg-policy" {
  name                   = "UI-asg-policy"
  scaling_adjustment     = 80
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.UI-asg.name}"
}



# =============================================데모 사항 new-API autoscaling group=============================================
resource "aws_autoscaling_group" "API-asg" {
  name               = "API-asg"
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  # health_check_type         = "ELB"
  health_check_grace_period = 300

  vpc_zone_identifier       = [
    "${aws_subnet.CRBS-subnet-private-c.id}", 
    "${aws_subnet.CRBS-subnet-private-2a.id}"
    ]
  termination_policies      = ["default"]
  # target_group_arns  = ["${aws_lb_target_group.CRBS-UI.arn}"]
  launch_template {
    id      = "${aws_launch_template.UI-template.id}"
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "API-asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "API-asg-policy" {
  name                   = "API-asg-policy"
  scaling_adjustment     = 80
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.API-asg.name}"
}



# ====================================================create RDS========================================

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
  engine_version       = "8.0.17"
  instance_class       = "db.t2.micro"
  username             = var.db_username
  password             = var.db_password
  port              = var.db_port
  db_subnet_group_name = aws_db_subnet_group.CRBS-rds-subnet-group.name
  multi_az             = true
  vpc_security_group_ids = [aws_security_group.CRBS-security_group-private.id]
  skip_final_snapshot = true
}




resource "aws_codedeploy_app" "CRBS-codedeploy-app" {
  name = "CRBS-codedeploy-app"
}

resource "aws_codedeploy_deployment_group" "CRBS-UI-deployment-group" {
  app_name               = aws_codedeploy_app.CRBS-codedeploy-app.name
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  deployment_group_name  = "CRBS-UI-deployment-group"
  service_role_arn       = "arn:aws:iam::144149479695:role/landingproject_codeDeploy_codeDeploy"
  autoscaling_groups     = [aws_autoscaling_group.UI-asg.name]
 

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
    green_fleet_provisioning_option {
      action                            = "COPY_AUTO_SCALING_GROUP"
      
    }
    
  }
  auto_rollback_configuration {
    enabled = false
  }
  

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_info {
        name = "${aws_lb_target_group.CRBS-UI.name}"
    }
  }
}

resource "aws_codedeploy_deployment_group" "CRBS-API-deployment-group" {
  app_name              = aws_codedeploy_app.CRBS-codedeploy-app.name
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  deployment_group_name = "CRBS-API-deployment-group"
  service_role_arn      = "arn:aws:iam::144149479695:role/landingproject_codeDeploy_codeDeploy"
  autoscaling_groups                = [aws_autoscaling_group.API-asg.name]

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
    green_fleet_provisioning_option {
      action                            = "COPY_AUTO_SCALING_GROUP"
      
    }
    
  }

    auto_rollback_configuration {
    enabled = false
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_info {
        name = "${aws_lb_target_group.CRBS-API.name}"
    }
  }
}
