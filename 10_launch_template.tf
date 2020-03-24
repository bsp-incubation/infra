# aws_launch_template
resource "aws_launch_template" "UI-template" {
  name = "UI_template"
  image_id = "${data.aws_ami.UI-ami.id}"
  instance_type = "t2.micro"
  key_name = var.key_name

  iam_instance_profile  {
    arn             = "${aws_iam_instance_profile.CRBS-instace_profile.arn}"
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = ["${aws_security_group.CRBS-security_group-public.id}"]
  }

  tag_specifications {
    resource_type = "instance"

  tags = {
      Name = "UI_template"
    }
  }
}

resource "aws_launch_template" "API-template" {
  name = "API_template"
  image_id = "${data.aws_ami.API-ami.id}"
  instance_type = "t2.micro"
  key_name = var.key_name

  iam_instance_profile  {
    arn             = "${aws_iam_instance_profile.CRBS-instace_profile.arn}"
  }

  network_interfaces {
    security_groups = ["${aws_security_group.CRBS-security_group-private.id}"]
  }

  tag_specifications {
    resource_type = "instance"

  tags = {
      Name = "API_template"
    }
  }
}