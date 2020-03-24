resource "aws_codedeploy_app" "CRBS-codedeploy-app" {
  name = "CRBS-codedeploy-app"
}

resource "aws_codedeploy_deployment_group" "CRBS-UI-deployment-group1" {
  app_name               = aws_codedeploy_app.CRBS-codedeploy-app.name
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  deployment_group_name  = "CRBS-UI-deployment-group1"
  service_role_arn       = "arn:aws:iam::144149479695:role/landingproject_codeDeploy_codeDeploy"

  autoscaling_groups     = [aws_autoscaling_group.UI-asg1.name]

  #  ec2_tag_set {
  #   ec2_tag_filter {
  #     key   = "Name"
  #     type  = "KEY_AND_VALUE"
  #     value = "UI-asg1"
  #   }
  # }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  load_balancer_info {
    target_group_info {
        name = "${aws_lb_target_group.CRBS-UI1.name}"
    }
  }
}

resource "aws_codedeploy_deployment_group" "CRBS-UI-deployment-group2" {
  app_name               = aws_codedeploy_app.CRBS-codedeploy-app.name
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  deployment_group_name  = "CRBS-UI-deployment-group2"
  service_role_arn       = "arn:aws:iam::144149479695:role/landingproject_codeDeploy_codeDeploy"

  autoscaling_groups     = [aws_autoscaling_group.UI-asg2.name]

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  load_balancer_info {
    target_group_info {
        name = "${aws_lb_target_group.CRBS-UI2.name}"
    }
  }
}

resource "aws_codedeploy_deployment_group" "CRBS-API-deployment-group1" {
  app_name              = aws_codedeploy_app.CRBS-codedeploy-app.name
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  deployment_group_name = "CRBS-API-deployment-group1"
  service_role_arn      = "arn:aws:iam::144149479695:role/landingproject_codeDeploy_codeDeploy"

  autoscaling_groups                = [aws_autoscaling_group.API-asg1.name]

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_info {
        name = "${aws_lb_target_group.CRBS-API1.name}"
    }
  }
}

resource "aws_codedeploy_deployment_group" "CRBS-API-deployment-group2" {
  app_name              = aws_codedeploy_app.CRBS-codedeploy-app.name
  deployment_config_name = "CodeDeployDefault.AllAtOnce"
  deployment_group_name = "CRBS-API-deployment-group2"
  service_role_arn      = "arn:aws:iam::144149479695:role/landingproject_codeDeploy_codeDeploy"

  autoscaling_groups                = [aws_autoscaling_group.API-asg2.name]

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  load_balancer_info {
    target_group_info {
        name = "${aws_lb_target_group.CRBS-API2.name}"
    }
  }
}