output "vpc_id" {
  value=module.vpc.id
}
output "public_subnet_a_id" {
  value=module.ui.CRBS-subnet-public-a
}
output "public_subnet_c_id" {
  value=module.ui.CRBS-subnet-public-c
}
output "private_subnet_a_id" {
  value=module.api.CRBS-subnet-private-a
}
output "private_subnet_c_id" {
  value=module.api.CRBS-subnet-private-c
}
output "igw_id" {
  value=module.crbs.CRBS-igw
}
output "nat_id" {
  value=module.crbs.CRBS-natgateway
}
output "route_table_public_id" {
  value=module.ui.CRBS-route_table-public
}
output "route_table_private_id" {
  value=module.api.CRBS-route_table-private
}
output "security_group_public_id" {
  value=module.ui.CRBS-security_group-public
}
output "security_group_private_id" {
  value=module.api.CRBS-security_group-private
}
output "ex_lb_arn" {
  value=module.ui.CRBS-external
}

output "in_lb_arn" {
  value=module.api.CRBS-internal
}

output "UI_asg1" {
  value=module.ui.UI-asg1
}

output "API_asg1" {
  value=module.api.API-asg1
}

output "UI_asg2" {
  value=module.ui.UI-asg2
}

output "API_asg2" {
  value=module.api.API-asg2
}

output "UI_tg1" {
  value=module.ui.UI_tg1
}

output "API_tg1" {
  value=module.api.API_tg1
}

output "UI_tg2" {
  value=module.ui.UI_tg2
}

output "API_tg2" {
  value=module.api.API_tg2
}

output "CRBS_rds_instance_id" {
  value=module.crbs.CRBS_rds_instance_id
}

output "CRBS_rds_instance_address" {
  value=module.crbs.CRBS_rds_instance_address
}

output "aws_codedeploy_app" {
  value=module.crbs.aws_codedeploy_app
}

output "dg_UI1" {
  value=module.ui.dg_UI1
}

output "dg_API1" {
  value=module.api.dg_API1
}

output "dg_UI2" {
  value=module.ui.dg_UI2
}

output "dg_API2" {
  value=module.api.dg_API2
}