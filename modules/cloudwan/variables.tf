
variable "global_network_description" {
  type        = string
  default     = "AWS CloudWAN Global Network"
  description = "Description for the Global Network"
}

variable "core_network_asn_ranges" {
  type        = list(string)
  default     = ["64512-64520"]
  description = "Private ASN ranges for Core Network"
}

variable "edge_locations" {
  type = map(object({
    inside_cidr_blocks = list(string)
  }))
  description = "Edge locations with inside CIDR blocks for tunnels"
  default = {
    "us-east-1" = {
      inside_cidr_blocks = ["169.254.0.0/28", "169.254.1.0/28"]
    },
    "us-west-1" = {
      inside_cidr_blocks = ["169.254.2.0/28", "169.254.3.0/28"]
    }
  }
}

variable "segments" {
  type = list(object({
    name                          = string
    description                   = string
    require_attachment_acceptance = bool
  }))
  default = [
    {
      name                          = "transit"
      description                   = "Transit segment for ingress/egress VPCs"
      require_attachment_acceptance = false
    },
    {
      name                          = "shared"
      description                   = "Shared services segment"
      require_attachment_acceptance = false
    },
    {
      name                          = "prod"
      description                   = "Production segment"
      require_attachment_acceptance = true
    },
    {
      name                          = "non-prod"
      description                   = "Non-production segment"
      require_attachment_acceptance = true
    }
  ]
}

variable "transit_segment_destination_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "Destination CIDRs for transit segment default route"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for all resources"
}

variable "vpc_attachments" {
  type = map(object({
    vpc_arn      = string
    subnet_arns  = list(string)
    segment_name = string
  }))
  description = "VPCs to attach to CloudWAN segments (keys: ingress, egress, shared_tools)"
}
