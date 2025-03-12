provider "aws" {
  
}
# VPC
resource "aws_vpc" "shared_tools" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = "${var.name}-shared-tools" })
}

# DNS Subnets
resource "aws_subnet" "dns" {
  count             = length(var.dns_subnet_cidrs)
  vpc_id            = aws_vpc.shared_tools.id
  cidr_block        = var.dns_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]
  tags              = merge(var.tags, { Name = "${var.name}-dns-${count.index}" })
}

# Attachment Subnets (for future Cloud WAN/TGW)
resource "aws_subnet" "attachment" {
  count             = length(var.attachment_subnet_cidrs)
  vpc_id            = aws_vpc.shared_tools.id
  cidr_block        = var.attachment_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]
  tags              = merge(var.tags, { Name = "${var.name}-attachment-${count.index}" })
}

/**
# Optional: Route 53 Resolver Endpoint
resource "aws_route53_resolver_endpoint" "dns" {
  name      = "${var.name}-dns-resolver"
  direction = "INBOUND"
  security_group_ids = [aws_security_group.dns.id]

  dynamic "ip_address" {
    for_each = aws_subnet.dns[*].id
    content {
      subnet_id = ip_address.value
    }
  }
  tags = var.tags
}
*/
# Security Group for DNS
resource "aws_security_group" "dns" {
  vpc_id = aws_vpc.shared_tools.id
  tags   = merge(var.tags, { Name = "${var.name}-dns-sg" })
}