resource "aws_route_table" "CRBS-route_table-public" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.CRBS-igw
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
