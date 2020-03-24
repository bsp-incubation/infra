# aws_launch_template
resource "aws_launch_template" "API-template" {
  name = "API_template"
  image_id = "${data.aws_ami.API-ami.id}"
  instance_type = "t2.micro"
  key_name = var.key_name

  iam_instance_profile  {
    arn             = var.CRBS-instace_profile
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