data "aws_ssm_parameter" "AmazonLinux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-6.1-arm64"
}

resource "aws_security_group" "all-egress" {
  name   = "all-egress"
  vpc_id = data.aws_vpc.default.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "TestInstance" {
  ami                    = data.aws_ssm_parameter.AmazonLinux.value
  instance_type          = "t4g.nano"
  iam_instance_profile   = aws_iam_instance_profile.test-ssm.name
  subnet_id              = data.aws_subnet.public-a.id
  vpc_security_group_ids = [aws_security_group.all-egress.id]
}

output "ssm-command" {
  value = "aws ssm start-session --target ${aws_instance.TestInstance.id} --region eu-west-1"
}

resource "aws_iam_role" "test-ssm" {
  name               = "TestSSMRole"
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Action": "sts:AssumeRole",
        "Principal": { "Service": [ "ec2.amazonaws.com" ] },
        "Effect": "Allow"
        }
    ]
  }
  EOF
}

resource "aws_iam_instance_profile" "test-ssm" {
  name = "TestSSMProfile"
  role = aws_iam_role.test-ssm.name
}

resource "aws_iam_role_policy_attachment" "test-ssm" {
  role       = aws_iam_role.test-ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
