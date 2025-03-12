output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.shared_tools.id
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.shared_tools.arn
}

output "dns_subnets" {
  description = "IDs of DNS subnets"
  value       = aws_subnet.dns[*].id
}

output "attachment_subnets_arns" {
  description = "ARNs of attachment subnets for CloudWAN"
  value       = aws_subnet.attachment[*].arn
}