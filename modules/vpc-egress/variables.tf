variable "name" {}
variable "cidr_block" {}
variable "public_subnet_cidrs" { type = list(string) }
variable "firewall_subnet_cidrs" { type = list(string) }
variable "attachment_subnet_cidrs" { type = list(string) } # NEW
variable "azs" { type = list(string) }
variable "tags" { default = {} }
variable "firewall_policy_arn" {
  type        = string
  description = "ARN of the AWS Network Firewall policy"
}