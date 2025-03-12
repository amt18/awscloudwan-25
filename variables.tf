
# Common Tags
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to all resources"
}

variable "ingress_vpcs" {
  type = map(object({
    name                    = string
    cidr_block              = string
    public_subnet_cidrs     = list(string)
    attachment_subnet_cidrs = list(string)
    azs                     = list(string)
  }))
}

variable "egress_vpcs" {
  type = map(object({
    name                    = string
    cidr_block              = string
    public_subnet_cidrs     = list(string)
    firewall_subnet_cidrs   = list(string)
    attachment_subnet_cidrs = list(string)
    firewall_policy_arn     = string
    azs                     = list(string)
  }))
}

# Shared Tools VPC (Single Region)
variable "shared_tools_vpc" {
  type = object({
    name                    = string
    cidr_block              = string
    dns_subnet_cidrs        = list(string)
    attachment_subnet_cidrs = list(string)
    azs                     = list(string)
  })
  description = "Configuration for Shared Tools VPC"
}