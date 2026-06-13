resource "aws_key_pair" "key" {
  key_name   = "my-tf-key"
  public_key = file("my-tf-key.pub")
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC" 
  }
}

resource "aws_security_group" "saad-sg" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
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
    Name = "tf-automated-sg"
  }
}

resource "aws_instance" "my-instance" {
  ami                    = var.ubuntu_image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.saad-sg.id]

  root_block_device {
    volume_size = var.ec2_volume_size
    volume_type = var.ec2_volume_type
  }

  tags = {
    Name = "Automated EC2"
  }
}