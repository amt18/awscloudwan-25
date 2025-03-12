
provider "aws" {
  
}

# Create Global Network
resource "aws_networkmanager_global_network" "cloudwan" {
  description = "AWS CloudWAN Global Network"
  tags        = var.tags
}

# Create Core Network
resource "aws_networkmanager_core_network" "cloudwan" {
  global_network_id = aws_networkmanager_global_network.cloudwan.id
  tags              = var.tags
}

# Core Network Policy Document
data "aws_networkmanager_core_network_policy_document" "cloudwan" {
  core_network_configuration {
    asn_ranges = ["64512-64520"]
    edge_locations {
      location          = "us-east-1"
      inside_cidr_blocks = ["169.254.10.0/28", "169.254.11.0/28"]
    }
    edge_locations {
      location          = "us-west-1"
      inside_cidr_blocks = ["169.254.20.0/28", "169.254.21.0/28"]
    }
  }

  # Segments
  segments {
    name                          = "transit"
    description                   = "Transit segment"
    require_attachment_acceptance = false
  }
  segments {
    name                          = "shared"
    description                   = "Shared segment"
    require_attachment_acceptance = false
  }
  segments {
    name                          = "prod"
    description                   = "Production segment"
    require_attachment_acceptance = true
  }
  segments {
    name                          = "nonprod"  # No hyphens!
    description                   = "Non-production segment"
    require_attachment_acceptance = true
  }

  # Route all traffic through the transit segment
  segment_actions {
    action     = "create-route"
    segment    = "transit"
    destination_cidr_blocks = ["0.0.0.0/0"]
    #mode       = "SHARED"  # Explicitly set the mode
  }
}

# Attach Policy to Core Network
resource "aws_networkmanager_core_network_policy_attachment" "cloudwan" {
  core_network_id = aws_networkmanager_core_network.cloudwan.id
  policy_document = data.aws_networkmanager_core_network_policy_document.cloudwan.json
}

# Attach VPCs to Segments
resource "aws_networkmanager_vpc_attachment" "this" {
  for_each        = var.vpc_attachments
  core_network_id = aws_networkmanager_core_network.cloudwan.id
  vpc_arn         = each.value.vpc_arn
  subnet_arns     = each.value.subnet_arns
  tags            = merge(var.tags, { Segment = each.value.segment_name })
  depends_on = [aws_networkmanager_core_network_policy_attachment.cloudwan]
}


