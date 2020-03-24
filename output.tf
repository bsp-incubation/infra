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
output "ex_lb_arn" {
  value="${aws_lb.CRBS-external.arn}"
}

output "in_lb_arn" {
  value="${aws_lb.CRBS-internal.arn}"
}

output "UI_asg1" {
  value="${aws_autoscaling_group.UI-asg1.name}"
}

output "API_asg1" {
  value="${aws_autoscaling_group.API-asg1.name}"
}

output "UI_asg2" {
  value="${aws_autoscaling_group.UI-asg2.name}"
}

output "API_asg2" {
  value="${aws_autoscaling_group.API-asg2.name}"
}

output "UI_tg1" {
  value="${aws_lb_target_group.CRBS-UI1.arn}"
}

output "API_tg1" {
  value="${aws_lb_target_group.CRBS-API1.arn}"
}

output "UI_tg2" {
  value="${aws_lb_target_group.CRBS-UI2.arn}"
}

output "API_tg2" {
  value="${aws_lb_target_group.CRBS-API2.arn}"
}

output "CRBS_rds_instance_id" {
  value="${aws_db_instance.CRBS-rds-instance.identifier}"
}

output "CRBS_rds_instance_address" {
  value="${aws_db_instance.CRBS-rds-instance.address}"
}

output "aws_codedeploy_app" {
  value="${aws_codedeploy_app.CRBS-codedeploy-app.name}"
}

output "dg_UI1" {
  value="${aws_codedeploy_deployment_group.CRBS-UI-deployment-group1.deployment_group_name}"
}

output "dg_API1" {
  value="${aws_codedeploy_deployment_group.CRBS-API-deployment-group1.deployment_group_name}"
}

output "dg_UI2" {
  value="${aws_codedeploy_deployment_group.CRBS-UI-deployment-group2.deployment_group_name}"
}

output "dg_API2" {
  value="${aws_codedeploy_deployment_group.CRBS-API-deployment-group2.deployment_group_name}"
}