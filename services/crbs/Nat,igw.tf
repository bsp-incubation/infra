# dev VPC에서 사용할 IGW를 정의한다.
# IGW는 AZ에 무관하게 한개의 IGW를 공유해서 사용할 수 있다.
resource "aws_internet_gateway" "CRBS-igw" {
  vpc_id = var.vpc_id
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
  subnet_id     = var.CRBS-subnet-public-a
  depends_on        = [aws_internet_gateway.CRBS-igw]
  tags = { Name = "CRBS-natgateway" }
}