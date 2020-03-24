resource "aws_route_table" "CRBS-route_table-private" {
  vpc_id = var.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.CRBS-natgateway
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

resource "aws_route_table_association" "CRBS-route_table_association-private-c" {
  subnet_id      = aws_subnet.CRBS-subnet-private-c.id
  route_table_id = aws_route_table.CRBS-route_table-private.id
}