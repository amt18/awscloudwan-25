provider "aws" {
  
}
# VPC
resource "aws_vpc" "ingress" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = "${var.name}-ingress" })
}

# Public Subnets (SD-WAN Appliances)
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.ingress.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index % length(var.azs)]
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, { Name = "${var.name}-public-${count.index}" })
}

# Attachment Subnets (for future Cloud WAN/TGW)
resource "aws_subnet" "attachment" {
  count             = length(var.attachment_subnet_cidrs)
  vpc_id            = aws_vpc.ingress.id
  cidr_block        = var.attachment_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]
  tags              = merge(var.tags, { Name = "${var.name}-attachment-${count.index}" })
}

# Internet Gateway
resource "aws_internet_gateway" "ingress" {
  vpc_id = aws_vpc.ingress.id
  tags   = merge(var.tags, { Name = "${var.name}-igw" })
}

# Public Route Table (Routes to IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ingress.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ingress.id
  }
  tags = merge(var.tags, { Name = "${var.name}-public-rt" })
}

# Associate Public Subnets
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}