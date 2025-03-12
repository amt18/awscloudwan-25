output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.ingress.id
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.ingress.arn
}

output "public_subnets" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "attachment_subnets_arns" {
  description = "ARNs of attachment subnets for CloudWAN"
  value       = aws_subnet.attachment[*].arn
}