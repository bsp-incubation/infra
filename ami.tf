data "aws_ami" "UI-ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["UI-ami*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["144149479695"]
}
data "aws_ami" "API-ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["API-ami*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["144149479695"]
}