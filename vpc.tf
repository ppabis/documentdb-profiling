data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "public-a" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "eu-west-1a"
}

data "aws_subnet" "public-b" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "eu-west-1b"

}

resource "aws_security_group" "documentdb" {
  vpc_id      = data.aws_vpc.default.id
  name        = "mycluster-sg"
  description = "Allows VPC access to DocumentDB cluster"
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
