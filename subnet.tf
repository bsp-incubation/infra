// 서브넷 설정
# 다음과 같이 2개의 AZ에 public, private subnet을 각각 1개씩 생성한다.
# ${aws_vpc.dev.id} 는 aws_vpc의 dev리소스로부터 id값을 가져와서 세팅한다.
# resource name은 {aws_subnet.public_1a.id} 와 같이 작성하기 쉽도록 underscore를 사용했다.
resource "aws_subnet" "CRBS-subnet-public-a" {
  vpc_id                    = aws_vpc.CRBS-vpc.id
  availability_zone         = var.my_az1
  cidr_block                = "172.16.1.0/24"
  map_public_ip_on_launch   = true
  tags = { Name = "CRBS-subnet-public-a" }
}

resource "aws_subnet" "CRBS-subnet-private-a" {
  vpc_id            = aws_vpc.CRBS-vpc.id
  availability_zone = var.my_az1
  cidr_block        = "172.16.3.0/24"
  map_public_ip_on_launch   = false
  tags = { Name = "CRBS-subnet-private-a" }
}

resource "aws_subnet" "CRBS-subnet-public-c" {
  vpc_id            = aws_vpc.CRBS-vpc.id
  availability_zone = var.my_az2
  cidr_block        = "172.16.2.0/24"
  map_public_ip_on_launch   = true
  tags = { Name = "CRBS-subnet-public-c" }
}

resource "aws_subnet" "CRBS-subnet-private-c" {
  vpc_id            = aws_vpc.CRBS-vpc.id
  availability_zone = var.my_az2
  cidr_block        = "172.16.4.0/24"
  map_public_ip_on_launch   = false
  tags = { Name = "CRBS-subnet-private-c" }
}