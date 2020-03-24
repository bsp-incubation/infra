# VPC peering 설정
resource "aws_vpc_peering_connection" "CRBS-vpc-peering" {
  peer_vpc_id   = "vpc-3a61a851"
  vpc_id        = var.vpc_id
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

# vpc peering 대상 route table
resource "aws_route" "default_vpc_routing" {
  route_table_id            = "rtb-3b32a450"
  destination_cidr_block    = "172.16.0.0/16"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.CRBS-vpc-peering.id}"
}

