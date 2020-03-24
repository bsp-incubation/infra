terraform {
  required_version = "~> 0.12.20"
  backend "local" {}
}

module "vpc" {
  source = "./vpc"

  my_region      = var.my_region
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
}


module "crbs" {
  source = "./services/crbs"

  # availability_zone
  availability_zone1 = var.my_az1
  availability_zone2 = var.my_az2

  # vpc
  vpc_id = module.vpc.id

  # for health check path
  external_path = var.target_group_external_path
  internal_path = var.target_group_internal_path

  # subnet
  CRBS-subnet-public-a = module.ui.public_subnet_a_id
  CRBS-subnet-public-c = module.ui.public_subnet_c_id
  CRBS-subnet-private-a = module.api.private_subnet_a_id
  CRBS-subnet-private-c = module.api.private_subnet_c_id

  # security group
  CRBS-security_group-private = module.api.security_group_private_id

  # RDS
  username             = var.db_username
  password             = var.db_password
  port                 = var.db_port

}

module "ui" {
  source = "./services/ui"

  # availability_zone
  availability_zone1 = var.my_az1
  availability_zone2 = var.my_az2

  # vpc
  vpc_id = module.vpc.id

  # igw
  CRBS-igw = module.crbs.igw_id

  # nat_gw
  CRBS-natgateway = module.crbs.nat_id

  # iam_instance_profile
  CRBS-instace_profile = module.crbs.aws_iam_instance_profile

  # aws_codedeploy_app
  CRBS-codedeploy-app = module.crbs.aws_codedeploy_app

}

module "api" {
  source = "./services/api"

  # availability_zone
  availability_zone1 = var.my_az1
  availability_zone2 = var.my_az2

  # vpc
  vpc_id = module.vpc.id

  # igw
  CRBS-igw = module.crbs.igw_id

  # nat_gw
  CRBS-natgateway = module.crbs.nat_id

  # iam_instance_profile
  CRBS-instace_profile = module.crbs.aws_iam_instance_profile

  # aws_codedeploy_app
  CRBS-codedeploy-app = module.crbs.aws_codedeploy_app

  CRBS-security_group-public = module.ui.security_group_public_id
}