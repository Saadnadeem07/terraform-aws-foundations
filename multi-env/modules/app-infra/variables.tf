variable "env" {
  description = "Environment"
  type        = string
  #default     = "eu-central-1"
}

variable "instance_count" {
  description = "Number of ec2 instances"
  type        = number
}

variable "ami_id" {
  description = "Linux ami_id"
  type        =  string
}
variable "instance_type" {
  description = "instance_type of ec2 instances e.g t2.micro etc"
  type        = string
}

variable "volume_size" {
  description = "volume_size of ec2 instances"
  type        =  number
}

#gp3 etc
variable "volume_type" {
  description = "volume_type of ec2 instances"
  type        =  string 
}