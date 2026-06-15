# output "public_ip" {
#   description = "Public IP address of the EC2 instance"
#   value       = aws_instance.web.public_ip
# }

# output "public_dns" {
#   description = "Public DNS name of the EC2 instance"
#   value       = aws_instance.web.public_dns
# }

# output "private_ip" {
#   description = "Private IP address of the EC2 instance"
#   value       = aws_instance.web.private_ip
# }

output "environment" {
  description = "The workspace/environment these resources belong to"
  value       = local.env
}

output "instances" {
  description = "Connection details for each EC2 instance, keyed by Name tag"

  value = {
    for instance in aws_instance.web : instance.tags["Name"] => {
      public_ip  = instance.public_ip
      public_dns = instance.public_dns
      private_ip = instance.private_ip
    }
  }
}
