variable "region" {
    default = "us-east-1"
    type    = string
    description = "region of aws ec2"
}

variable "instance_type" {
  default     = "t2.micro"
  type        = string
  description = "The EC2 instance size to deploy" 
}

variable "ubuntu_image_id" {
  default     = "ami-0b6d9d3d33ba97d99"
  type        = string
  description = "The ubuntu ami id" 
}

variable "ec2_volume_size" {
    default = 15
    type = number
}
variable "ec2_volume_type" {
    default = "gp3"
    type = string
}