variable "name" {}
variable "cidr_block" {}
variable "dns_subnet_cidrs" { type = list(string) }
variable "attachment_subnet_cidrs" { type = list(string) } # NEW
variable "azs" { type = list(string) }
variable "tags" { default = {} }