
output "transit_segment_name" {
  value = "transit"
}

output "shared_segment_name" {
  value = "shared"
}

output "core_network_id" {
  value = aws_networkmanager_core_network.cloudwan.id
}

output "vpc_attachment_ids" {
  description = "Map of VPC attachment names to their IDs"
  value       = { for k, v in aws_networkmanager_vpc_attachment.this : k => v.id }
}

