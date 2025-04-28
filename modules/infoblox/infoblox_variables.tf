variable "name" {
  type        = string
  description = "A unique name for the vNIOS-X instance."
}

variable "ami_id" {
  type        = string
  description = "The AMI ID for the Infoblox vNIOS-X appliance."
}

variable "instance_type" {
  type        = string
  description = "The EC2 instance type for vNIOS-X (e.g., m5.xlarge)."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet in the Shared VPC to deploy vNIOS-X."
}

variable "security_group_ids" {
  type        = list(string)
  description = "A list of security group IDs to associate with vNIOS-X."
}

variable "key_name" {
  type        = string
  description = "The name of the EC2 key pair for SSH access (optional)."
  default     = ""
}

variable "private_ip" {
  type        = string
  description = "The desired private IP address for vNIOS-X (optional, leave empty for DHCP)."
  default     = ""
}

variable "allocate_eip" {
  type        = bool
  description = "Whether to allocate an Elastic IP address for vNIOS-X."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to the vNIOS-X resources."
  default     = {}
}