

resource "aws_key_pair" "key" {
  key_name   = "${var.env}-key-pair"
  public_key = file("my-tf-key.pub")
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "web" {
  name        = "${var.env}-infra-app-sg"
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
    Name = "${var.env}-infra-app-sg"
    environment = var.env
  }
}

resource "aws_instance" "web" {
  
  count = var.instance_count
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.web.id]

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  tags = {
    Name = "${var.env}-infra-app-ec2"
    environment = var.env
  }
}