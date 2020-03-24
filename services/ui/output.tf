output "public_subnet_a_id" {
  value="${aws_subnet.CRBS-subnet-public-a.id}"
}
output "public_subnet_c_id" {
  value="${aws_subnet.CRBS-subnet-public-c.id}"
}

output "route_table_public_id" {
  value="${aws_route_table.CRBS-route_table-public.id}"
}
output "security_group_public_id" {
  value="${aws_security_group.CRBS-security_group-public.id}"
}

output "ex_lb_arn" {
  value="${aws_lb.CRBS-external.arn}"
}

output "UI_asg1" {
  value="${aws_autoscaling_group.UI-asg1.name}"
}

output "UI_asg2" {
  value="${aws_autoscaling_group.UI-asg2.name}"
}


output "UI_tg1" {
  value="${aws_lb_target_group.CRBS-UI1.arn}"
}


output "UI_tg2" {
  value="${aws_lb_target_group.CRBS-UI2.arn}"
}


output "dg_UI1" {
  value="${aws_codedeploy_deployment_group.CRBS-UI-deployment-group1.deployment_group_name}"
}


output "dg_UI2" {
  value="${aws_codedeploy_deployment_group.CRBS-UI-deployment-group2.deployment_group_name}"
}
