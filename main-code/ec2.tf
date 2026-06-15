data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "key" {
  key_name   = "my-tf-key-${local.env}"
  public_key = file("my-tf-key.pub")
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "web" {
  name        = "web-sg-${local.env}"
  description = "Allow SSH, HTTP, and HTTPS inbound and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id
  #inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Opened the SSH port"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Opened the HTTPS port"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Opened the HTTP port"
  }
  #outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1" # semantically equivalent to all ports
  }
  tags = {
    Name = "tf-automated-sg-${local.env}"
  }
}

resource "aws_instance" "web" {
  # Number of instances comes from the per-environment config.
  count = local.config.instance_count

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = local.config.instance_type
  key_name               = aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.web.id]

  root_block_device {
    volume_size = local.config.ec2_volume_size
    volume_type = var.ec2_volume_type
  }

  tags = {
    Name = "${local.env}-web-${count.index}"
  }
}