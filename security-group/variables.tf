
variable "aws_vpc_id" { }

variable "external_jump_box_sg_name" {
  default     = {}
}

variable "external_jump_box_sg_description" {
  default     = {}
}

variable "external_jump_box_sg_tags" {
  default     = {}
}

variable "external_jump_box_ingress_rules" {
    //  cidr_blocks  = list(string)
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
    }))
}

variable "external_jump_box_egress_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      source_security_group_id = string
      description = string
    }))
}

variable "external_jump_box_cidr_egress_rules" {
    //  cidr_blocks  = list(string)
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
    }))
}

/////////////////


variable "eks_master_sg_name" {
  default     = {}
}

variable "eks_master_sg_description" {
  default     = {}
}

variable "eks_master_sg_tags" {
  default     = {}
}

variable "eks_master_ingress_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      source_security_group_id = string
      description = string
    }))
}

variable "eks_master_egress_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      source_security_group_id = string
      description = string
    }))
}


/*
variable "eks_worker_sg_name" {
  default     = {}
}

variable "eks_worker_sg_description" {
  default     = {}
}

variable "eks_worker_sg_tags" {
  default     = {}
}

variable "eks_worker_ingress_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      source_security_group_id = string
      description = string
    }))
}

variable "eks_worker_egress_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      source_security_group_id = string
      description = string
    }))
}

variable "eks_worker_cidr_egress_rules" {
    //  cidr_blocks  = list(string)
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
    }))
}
*/

// Worker Node Groups Security Groups Variable Begins
variable "eks_worker_node_groups_one_sg_names" {

}

variable "eks_worker_node_groups_one_sg_description" {

}

variable "eks_worker_node_groups_one_sg_tags" {

}

variable "eks_worker_node_groups_one_ingress_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      source_security_group_id = string
      description = string
    }))
}

variable "eks_worker_node_groups_one_egress_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      source_security_group_id = string
      description = string
    }))
}

variable "eks_worker_node_groups_one_cidr_egress_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
    }))
}

// Worker Node Groups Security Groups Variable Ends




variable "eks_cluster_name" {
    description = "Tag needed to tag the security group of the worker nodes"
}


variable "vpce_sg_name" {
  description = "The Security Group name for the VPCE"
  default     = {}
}

variable "vpce_sg_description" {
  description = "The Security Group description for the VPCE"
  default     = {}
}


variable "vpce_sg_tags" {
  description = "The VPCE tags for the Security Group"
  default     = {}
}


variable "vpce_ingress_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      source_security_group_id = string
      description = string
    }))
}

variable "vpce_egress_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      source_security_group_id = string
      description = string
    }))
}

variable "vpce_cidr_ingress_rules" {
    //  cidr_blocks  = list(string)
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
    }))
}