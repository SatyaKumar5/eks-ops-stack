variable "vpc_cidr_base" {
    description = "Base CIDR for the VPC"
}

variable "aws_vpc_id" {
    description = "ID of the VPC"
}


variable "single_nat_gateway" {

}

variable "az_count" {

}

variable "nat_gateways_ids" {
  
}

variable "internet_gateway_id" {
  
}

variable "aws_azs" {
  description = "comma separated string of availability zones in order of precedence"
  type = list(string)
}

variable "global_tags" {
  description = "AWS tags that will be added to all resources managed herein"
  type = map(string)
}

variable "provision_internet_gateway" {
  
}

variable "provision_nat_gateways" {
  
}




variable "db_subnet_cidrs" {
  description = "CIDRs for the DB subnets"
  type = map(string)
}



variable "proxy_subnet_cidrs" {
  description = "CIDRs for the Proxy subnets"
  type = map(string)
}


variable "public_subnet_tags" {
  description = "Tags to apply to the public subnets"
  default     = {}
}



variable "private_subnet_tags" {
  description = "Tags to apply to the private production subnets"
  default     = {}
}

variable "internet_gateway_tags" {
  description = "Tags to apply to the internet gateway"
  default = {}
}

variable "multi_az_nat_gateway" {
  description = "place a NAT gateway in each AZ"
  type = number
}



variable "eks_internal_lb_tags" {
  description = "EKS related tags for the internal istio load balancer"
  default = {} 
}
variable "eks_worker_node_tags" {
  description = "EKS related tags for the worker nodes"
  default = {} 
}


// ------ Added new changes START ------------------------

variable "control_plane_zone_subnet_name_tags" {
  description = "Name tags for the Control Plane subnets"
  type = map(string)
}

variable "control_plane_zone_subnet_cidrs" {
  description = "CIDRs for the Control Plane subnets"
  type = map(string)
}





// Public Subnets Configuration Starts
variable "public_subnet_cidrs" {
  description = "CIDRs for the public subnets"
  type = map(string)
}

variable "public_subnet_name_tags" {
  description = "Name tags for the public subnets"
  type = map(string)
}

// Public Subnets COnfiguration Ends



// Management Subnets Configutarion Starts
variable "management_subnet_cidrs" {
  description = "CIDRs for the management subnets"
  type = map(string)
}

variable "management_subnet_name_tags" {
  description = "Name tags for the management subnets"
  type = map(string)
}

// Management Subnets Configutarion ENds


variable "worker_nodes_one_subnet_cidrs" {
  description = "CIDRs for the worker nodes one subnets"
  type = map(string)
}

variable "worker_nodes_one_subnet_name_tags"{
  description = "Tags to apply to the worker nodes one subnets"
  default     = {}
}


// ------- Added new changes END --------------------------



 

// ------- Toggle Variables to create Subnets
variable "provision_public_subnets" {
  
}

variable "provision_control_plane_subnets" {
  
}

variable "provision_management_subnets" {
  
}

variable "provision_worker_nodes_one_subnets" {
  
}


// ------ Variables to pass the subnet ids if the subnets are already existing

variable "public_subnet_ids" {
  
}

variable "control_plane_subnet_ids" {
  
}

variable "worker_nodes_one_subnet_ids" {
  
}
