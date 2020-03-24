# =============================================UI autoscaling group=============================================
resource "aws_autoscaling_group" "UI-asg1" {
  name               = "UI-asg1"
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier       = [
    "${aws_subnet.CRBS-subnet-public-c.id}", 
    "${aws_subnet.CRBS-subnet-public-a.id}"
    ]

  termination_policies      = ["default"]
  # target_group_arns  = ["${aws_lb_target_group.CRBS-UI.arn}"]
  launch_template {
    id      = "${aws_launch_template.UI-template.id}"
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "UI-asg1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "UI-asg1-policy" {
  name                   = "UI-asg1-policy"
  scaling_adjustment     = 80
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.UI-asg1.name}"
}

resource "aws_autoscaling_group" "UI-asg2" {
  name               = "UI-asg2"
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier       = [
    "${aws_subnet.CRBS-subnet-public-c.id}", 
    "${aws_subnet.CRBS-subnet-public-a.id}"
    ]

  termination_policies      = ["default"]
  # target_group_arns  = ["${aws_lb_target_group.CRBS-UI.arn}"]
  launch_template {
    id      = "${aws_launch_template.UI-template.id}"
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "UI-asg2"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "UI-asg2-policy" {
  name                   = "UI-asg2-policy"
  scaling_adjustment     = 80
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.UI-asg2.name}"
}


# =============================================API autoscaling group=============================================
resource "aws_autoscaling_group" "API-asg1" {
  name               = "API-asg1"
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier       = [
    "${aws_subnet.CRBS-subnet-private-c.id}", 
    "${aws_subnet.CRBS-subnet-private-a.id}"
    ]

  termination_policies      = ["default"]
  # target_group_arns  = ["${aws_lb_target_group.CRBS-UI.arn}"]
  launch_template {
    id      = "${aws_launch_template.API-template.id}"
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "API-asg1"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "API-asg1-policy" {
  name                   = "API-asg1-policy"
  scaling_adjustment     = 80
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.API-asg1.name}"
}

resource "aws_autoscaling_group" "API-asg2" {
  name               = "API-asg2"
  desired_capacity   = 2
  max_size           = 4
  min_size           = 2
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier       = [
    "${aws_subnet.CRBS-subnet-private-c.id}", 
    "${aws_subnet.CRBS-subnet-private-a.id}"
    ]

  termination_policies      = ["default"]
  # target_group_arns  = ["${aws_lb_target_group.CRBS-UI.arn}"]
  launch_template {
    id      = "${aws_launch_template.API-template.id}"
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "API-asg2"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "API-asg2-policy" {
  name                   = "API-asg2-policy"
  scaling_adjustment     = 80
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.API-asg2.name}"
}