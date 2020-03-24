resource "aws_route_table" "CRBS-route_table-public" {
  vpc_id = aws_vpc.CRBS-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.CRBS-igw.id
  }
  tags = { Name = "CRBS-route_table-public" }
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
    nat_gateway_id = aws_nat_gateway.CRBS-natgateway.id
  }
  route {
    cidr_block     = "172.31.0.0/16"
    vpc_peering_connection_id = "${aws_vpc_peering_connection.CRBS-vpc-peering.id}"
  }
  tags = { Name = "CRBS-route_table-private" }
}

resource "aws_route_table_association" "CRBS-route_table_association-private-a" {
  subnet_id      = aws_subnet.CRBS-subnet-private-a.id
  route_table_id = aws_route_table.CRBS-route_table-private.id
}