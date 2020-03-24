# aws_launch_template
resource "aws_launch_template" "UI-template" {
  name = "UI_template"
  image_id = "${data.aws_ami.UI-ami.id}"
  instance_type = "t2.micro"
  key_name = var.key_name

  iam_instance_profile  {
    arn             = var.CRBS-instace_profile
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
