
// Fetch all the AZs in the given regione
data "aws_availability_zones" "azs" {
  state = "available"
}

// Fetch the VPC based on the VPC ID
data "aws_vpc" "selected" {
  count = local.provision_vpc == false ? 1 : 0
  id = local.existing_vpc_id
}

locals {
  existing_vpc_base_cidr = local.provision_vpc == false ? regex("[0-9]+\\.[0-9]+", data.aws_vpc.selected[0].cidr_block) : 0
  // If Provision VPC is False, than it will override the base CIDR that is provided in the locals.tf
  vpc_base_cidr = local.provision_vpc == false ? regex("[0-9]+\\.[0-9]+", data.aws_vpc.selected[0].cidr_block) : 0
  
  existing_vpc_complete_cidr = local.provision_vpc == false ? data.aws_vpc.selected[0].cidr_block : 0
  availability_zones = data.aws_availability_zones.azs.names
}

data "aws_caller_identity" "account_details" {}

output "aws_account_id" {
  value = data.aws_caller_identity.account_details.account_id
}

data "aws_ami" "latest-ubuntu" {
most_recent = true
owners =  ["099720109477"]

  filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}