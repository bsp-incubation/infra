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
  value="${aws_nat_gateway.CRBS-natgateway.id}"
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

output "CRBS_external_dns_name" {
  value="${aws_lb.CRBS-external.dns_name}"
}

output "CRBS_internal_dns_name" {
  value="${aws_lb.CRBS-internal.dns_name}"
}

output "UI_asg" {
  value="${aws_autoscaling_group.UI-asg.name}"
}

output "API_asg" {
  value="${aws_autoscaling_group.API-asg.name}"
}

output "CRBS_rds_instance_address" {
  value="${aws_db_instance.CRBS-rds-instance.address}"
}

output "CRBS_rds_instance_id" {
  value="${aws_db_instance.CRBS-rds-instance.identifier}"
}

output "aws_codedeploy_app" {
  value="${aws_codedeploy_app.CRBS-codedeploy-app.name}"
}

output "aws_codedeploy_deployment_group_UI" {
  value="${aws_codedeploy_deployment_group.CRBS-UI-deployment-group.deployment_group_name}"
}

output "aws_codedeploy_deployment_group_API" {
  value="${aws_codedeploy_deployment_group.CRBS-API-deployment-group.deployment_group_name}"
}


# 데모 변동

output "public_subnet_2a_id" {
  value="${aws_subnet.CRBS-subnet-public-2a.id}"
}
output "private_subnet_2a_id" {
  value="${aws_subnet.CRBS-subnet-private-2a.id}"
}
