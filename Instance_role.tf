resource "aws_iam_role" "CRBS-instace_role" {
  name = "CRBS-instace_role"

  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow"
        }
      ]
    }
EOF
}

resource "aws_iam_policy" "CRBS-instace_policy" {
  name        = "CRBS-instace_policy"
  description = "CRBS-instace_policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "CRBS-instace_role_policy-attach" {
  role       = "${aws_iam_role.CRBS-instace_role.name}"
  policy_arn = "${aws_iam_policy.CRBS-instace_policy.arn}"
}

resource "aws_iam_instance_profile" "CRBS-instace_profile" {
  name = "CRBS-instace_profile"
  role = "${aws_iam_role.CRBS-instace_role.name}"
}