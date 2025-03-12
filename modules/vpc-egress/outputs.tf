output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.egress.id
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.egress.arn
}

output "public_subnets" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "firewall_subnets" {
  description = "IDs of firewall subnets"
  value       = aws_subnet.firewall[*].id
}

output "attachment_subnets_arns" {
  description = "ARNs of attachment subnets for CloudWAN"
  value       = aws_subnet.attachment[*].arn
}