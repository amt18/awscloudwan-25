terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

# Primary provider (us-east-1)
provider "aws" {
  region = "us-east-1"
  alias  = "east"
}

# Secondary provider (us-west-1)
provider "aws" {
  region = "us-west-1"
  alias  = "west"
}