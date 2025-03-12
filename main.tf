/*
# Deploy Ingress VPC in us-east-1
module "ingress_east" {
  source = "./modules/vpc-ingress"
  providers = {
    aws = aws.east # Static reference to the east provider
  }

  name                    = var.ingress_vpcs["us-east-1"].name
  cidr_block              = var.ingress_vpcs["us-east-1"].cidr_block
  public_subnet_cidrs     = var.ingress_vpcs["us-east-1"].public_subnet_cidrs
  attachment_subnet_cidrs = var.ingress_vpcs["us-east-1"].attachment_subnet_cidrs
  azs                     = var.ingress_vpcs["us-east-1"].azs
  tags                    = var.tags
}

# Deploy Ingress VPC in us-west-1
module "ingress_west" {
  source = "./modules/vpc-ingress"
  providers = {
    aws = aws.west # Static reference to the west provider
  }

  name                    = var.ingress_vpcs["us-west-1"].name
  cidr_block              = var.ingress_vpcs["us-west-1"].cidr_block
  public_subnet_cidrs     = var.ingress_vpcs["us-west-1"].public_subnet_cidrs
  attachment_subnet_cidrs = var.ingress_vpcs["us-west-1"].attachment_subnet_cidrs
  azs                     = var.ingress_vpcs["us-west-1"].azs
  tags                    = var.tags
}

# Deploy Egress VPC in us-east-1
module "egress_east" {
  source = "./modules/vpc-egress"
  providers = {
    aws = aws.east
  }

  name                    = var.egress_vpcs["us-east-1"].name
  cidr_block              = var.egress_vpcs["us-east-1"].cidr_block
  public_subnet_cidrs     = var.egress_vpcs["us-east-1"].public_subnet_cidrs
  firewall_subnet_cidrs   = var.egress_vpcs["us-east-1"].firewall_subnet_cidrs
  attachment_subnet_cidrs = var.egress_vpcs["us-east-1"].attachment_subnet_cidrs
  firewall_policy_arn     = var.egress_vpcs["us-east-1"].firewall_policy_arn
  azs                     = var.egress_vpcs["us-east-1"].azs
  tags                    = var.tags
}

# Deploy Egress VPC in us-west-1
module "egress_west" {
  source = "./modules/vpc-egress"
  providers = {
    aws = aws.west
  }

  name                    = var.egress_vpcs["us-west-1"].name
  cidr_block              = var.egress_vpcs["us-west-1"].cidr_block
  public_subnet_cidrs     = var.egress_vpcs["us-west-1"].public_subnet_cidrs
  firewall_subnet_cidrs   = var.egress_vpcs["us-west-1"].firewall_subnet_cidrs
  attachment_subnet_cidrs = var.egress_vpcs["us-west-1"].attachment_subnet_cidrs
  firewall_policy_arn     = var.egress_vpcs["us-west-1"].firewall_policy_arn
  azs                     = var.egress_vpcs["us-west-1"].azs
  tags                    = var.tags
}

# Deploy Shared Tools VPC (single region)
module "shared_tools" {
  source = "./modules/vpc-shared-tools"
  # providers = { aws = aws.east } # Deploy in us-east-1

  name                    = var.shared_tools_vpc.name
  cidr_block              = var.shared_tools_vpc.cidr_block
  dns_subnet_cidrs        = var.shared_tools_vpc.dns_subnet_cidrs
  attachment_subnet_cidrs = var.shared_tools_vpc.attachment_subnet_cidrs
  azs                     = var.shared_tools_vpc.azs
  tags                    = var.tags
}

# Deploy CloudWAN after VPCs
# Deploy CloudWAN after VPCs
module "cloudwan" {
  source = "./modules/cloudwan"
  tags   = var.tags

  # Pass VPC attachment details
  vpc_attachments = {
    ingress = {
      vpc_arn      = module.ingress_east.vpc_arn
      subnet_arns  = module.ingress_east.attachment_subnets_arns
      segment_name = "transit"
    }
    egress = {
      vpc_arn      = module.egress_east.vpc_arn
      subnet_arns  = module.egress_east.attachment_subnets_arns
      segment_name = "transit"
    }
    shared_tools = {
      vpc_arn      = module.shared_tools.vpc_arn
      subnet_arns  = module.shared_tools.attachment_subnets_arns
      segment_name = "shared"
    }
  }
}
*/