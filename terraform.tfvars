tags = {
  Environment = "prod"
  Project     = "landing-zone"
}

ingress_vpcs = {
  "us-east-1" = {
    name                    = "ingress-east",
    cidr_block              = "10.1.0.0/16",
    public_subnet_cidrs     = ["10.1.1.0/24", "10.1.2.0/24"],
    attachment_subnet_cidrs = ["10.1.3.0/24", "10.1.4.0/24"],
    azs                     = ["us-east-1a", "us-east-1b"]
  },
  "us-west-1" = {
    name                    = "ingress-west",
    cidr_block              = "10.2.0.0/16",
    public_subnet_cidrs     = ["10.2.1.0/24", "10.2.2.0/24"],
    attachment_subnet_cidrs = ["10.2.3.0/24", "10.2.4.0/24"],
    azs                     = ["us-west-1a", "us-west-1c"]
  }
}

egress_vpcs = {
  "us-east-1" = {
    name                    = "egress-east",
    cidr_block              = "10.3.0.0/16",
    public_subnet_cidrs     = ["10.3.1.0/24", "10.3.2.0/24"],
    firewall_subnet_cidrs   = ["10.3.3.0/24", "10.3.4.0/24"],
    attachment_subnet_cidrs = ["10.3.5.0/24", "10.3.6.0/24"],
    firewall_policy_arn     = "arn:aws:network-firewall:us-east-1:936057499069:firewall-policy/poluseast1",
    azs                     = ["us-east-1a", "us-east-1b"]
  },
  "us-west-1" = {
    name                    = "egress-west",
    cidr_block              = "10.4.0.0/16",
    public_subnet_cidrs     = ["10.4.1.0/24", "10.4.2.0/24"],
    firewall_subnet_cidrs   = ["10.4.3.0/24", "10.4.4.0/24"],
    attachment_subnet_cidrs = ["10.4.5.0/24", "10.4.6.0/24"],
    firewall_policy_arn     = "arn:aws:network-firewall:us-west-1:936057499069:firewall-policy/poluswest1",
    azs                     = ["us-west-1a", "us-west-1c"]
  }
}
# Shared Tools VPC
shared_tools_vpc = {
  name                    = "shared-tools"
  cidr_block              = "10.5.0.0/16"
  dns_subnet_cidrs        = ["10.5.1.0/24", "10.5.2.0/24"]
  attachment_subnet_cidrs = ["10.5.3.0/24", "10.5.4.0/24"]
  azs                     = ["us-east-1a", "us-east-1b"]
}