provider "aws" {
  
}
# VPC
resource "aws_vpc" "egress" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = "${var.name}-egress" })
}

# Public Subnets (NAT Gateway)
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.egress.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index % length(var.azs)]
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { Name = "${var.name}-public-${count.index}" })
}

# Internet Gateway (IGW)
resource "aws_internet_gateway" "egress" {
  vpc_id = aws_vpc.egress.id
  tags   = merge(var.tags, { Name = "${var.name}-igw" })
}

# Public Route Table (Routes to IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.egress.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.egress.id
  }
  tags = merge(var.tags, { Name = "${var.name}-public-rt" })
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
# Private Subnets (AWS Network Firewall)
resource "aws_subnet" "firewall" {
  count             = length(var.firewall_subnet_cidrs)
  vpc_id            = aws_vpc.egress.id
  cidr_block        = var.firewall_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]
  tags              = merge(var.tags, { Name = "${var.name}-firewall-${count.index}" })
}

# Attachment Subnets (for future Cloud WAN/TGW)
resource "aws_subnet" "attachment" {
  count             = length(var.attachment_subnet_cidrs)
  vpc_id            = aws_vpc.egress.id
  cidr_block        = var.attachment_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]
  tags              = merge(var.tags, { Name = "${var.name}-attachment-${count.index}" })
}

# NAT Gateway
resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidrs)
  tags  = merge(var.tags, { Name = "${var.name}-nat-eip-${count.index}" })
}

resource "aws_nat_gateway" "egress" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags          = merge(var.tags, { Name = "${var.name}-nat-gw-${count.index}" })
}

# AWS Network Firewall
resource "aws_networkfirewall_firewall" "this" {
  name                = "${var.name}-anfw"
  firewall_policy_arn = var.firewall_policy_arn
  vpc_id              = aws_vpc.egress.id
  subnet_mapping {
    subnet_id = aws_subnet.firewall[0].id # Use first firewall subnet
  }
  tags = var.tags
}

# Route Tables for Private Subnets (to NAT Gateway)
resource "aws_route_table" "private" {
  count  = length(var.firewall_subnet_cidrs)
  vpc_id = aws_vpc.egress.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.egress[count.index].id
  }
  tags = merge(var.tags, { Name = "${var.name}-private-rt-${count.index}" })
}

# Associate Firewall Subnets
resource "aws_route_table_association" "firewall" {
  count          = length(aws_subnet.firewall)
  subnet_id      = aws_subnet.firewall[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}