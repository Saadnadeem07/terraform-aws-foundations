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

output "public_ips" {
    value = [
        for instance in aws_instance.web : instance.public_ip

    ]
}

output "private_ips" {
    value = [
        for instance in aws_instance.web : instance.private_ip
    ]
}

output "public_dns" {
    value = [
        for instance in aws_instance.web : instance.public_dns
    ]
}