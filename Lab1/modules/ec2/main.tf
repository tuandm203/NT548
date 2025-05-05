resource "aws_instance" "ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  associate_public_ip_address = true

  # vpc_security_group_ids = var.allowed_ip_range

  tags = {
    Name = "EC2 Instance"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow inbound access"

  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ip_range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_vpc" "default" {
  default = true
}
