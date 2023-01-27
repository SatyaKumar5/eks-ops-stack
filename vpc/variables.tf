data "aws_availability_zones" "aws_azs" {}

variable "aws_vpc_name" {
  description = "name of the VPC"
  type = string
}

variable "az_count" {
  description = "number of active availability zones in VPC"
 // default     = "3"
  type = string
}

variable "vpc_cidr_base" {
  //default = "10.20"
  type = string
}

variable "vpc_end_cidr" {
  type = string
}

variable "vpc_instance_tenancy" {
  type = string
}

variable "vpc_enable_dns_support" {
  type = string
}

variable "vpc_enable_dns_hostnames" {
  type = string
}

variable "vpc_enable_classiclink" {
  type = string
}

variable "global_tags" {
  description = "AWS tags that will be added to all resources managed herein"
  type = map(string)
}

variable "provision_vpc" {
  
}