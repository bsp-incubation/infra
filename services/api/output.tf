output "private_subnet_a_id" {
  value="${aws_subnet.CRBS-subnet-private-a.id}"
}
output "private_subnet_c_id" {
  value="${aws_subnet.CRBS-subnet-private-c.id}"
}
output "route_table_private_id" {
  value="${aws_route_table.CRBS-route_table-private.id}"
}
output "security_group_private_id" {
  value="${aws_security_group.CRBS-security_group-private.id}"
}

output "in_lb_arn" {
  value="${aws_lb.CRBS-internal.arn}"
}

output "API_asg1" {
  value="${aws_autoscaling_group.API-asg1.name}"
}

output "API_asg2" {
  value="${aws_autoscaling_group.API-asg2.name}"
}

output "API_tg1" {
  value="${aws_lb_target_group.CRBS-API1.arn}"
}

output "API_tg2" {
  value="${aws_lb_target_group.CRBS-API2.arn}"
}

output "dg_API1" {
  value="${aws_codedeploy_deployment_group.CRBS-API-deployment-group1.deployment_group_name}"
}

output "dg_API2" {
  value="${aws_codedeploy_deployment_group.CRBS-API-deployment-group2.deployment_group_name}"
}