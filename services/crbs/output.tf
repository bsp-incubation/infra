output "igw_id" {
  value="${aws_internet_gateway.CRBS-igw.id}"
}
output "nat_id" {
  value="${aws_nat_gateway.CRBS-natgateway.id}"
}
output "ex_lb_arn" {
  value="${aws_lb.CRBS-external.arn}"
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

output "aws_iam_instance_profile" {
  value="${aws_iam_instance_profile.CRBS-instace_profile.arn}"
}