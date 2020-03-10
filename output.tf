output "vpc_id" {
  value="${aws_vpc.CRBS-vpc.id}"
}
output "public_subnet_a_id" {
  value="${aws_subnet.CRBS-subnet-public-a.id}"
}
output "public_subnet_c_id" {
  value="${aws_subnet.CRBS-subnet-public-c.id}"
}
output "private_subnet_a_id" {
  value="${aws_subnet.CRBS-subnet-private-a.id}"
}
output "private_subnet_c_id" {
  value="${aws_subnet.CRBS-subnet-private-c.id}"
}
output "igw_id" {
  value="${aws_internet_gateway.CRBS-igw.id}"
}
output "nat_id" {
  value="${aws_nat_gateway.CRBS-nat.id}"
}
output "route_table_public_id" {
  value="${aws_route_table.CRBS-route_table-public.id}"
}
output "route_table_private_id" {
  value="${aws_route_table.CRBS-route_table-private.id}"
}
output "security_group_public_id" {
  value="${aws_security_group.CRBS-security_group-public.id}"
}
output "security_group_private_id" {
  value="${aws_security_group.CRBS-security_group-private.id}"
}
