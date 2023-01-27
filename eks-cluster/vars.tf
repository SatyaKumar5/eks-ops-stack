variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type = string
}

variable "node_group_names" {
  description = "Name of the Node Group"
  type = list(string)
}

variable "environment" {
  type        = string
  description = "Application enviroment"
}

variable "endpoint_private_access" {
  type = bool
  default = true
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
}

variable "endpoint_public_access" {
  type = bool
  default = true
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled."
}

variable "eks_cluster_subnet_ids" {
  type = list(string)
  description = "List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane."
}

variable "private_subnet_ids" {
  type = list(string)
  description = "List of private subnet IDs."
}

/*
variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group. Defaults to AL2_x86_64. Valid values: AL2_x86_64, AL2_x86_64_GPU."
  type = string 
  default = "ami-06c9b6a12f5bd0a96"
}
*/

variable "disk_sizes" {
  description = "Disk size in GiB for worker nodes. Defaults to 20."
  type = list(number)
}

variable "instance_types" {
 // type = list(string)
  description = "Set of instance types associated with the EKS Node Group."
}

/*
variable "pvt_desired_size" {
  description = "Desired number of worker nodes in private subnet"
  default = 1
  type = number
}

variable "pvt_max_size" {
  description = "Maximum number of worker nodes in private subnet."
  default = 1
  type = number
}

variable "pvt_min_size" {
  description = "Minimum number of worker nodes in private subnet."
  default = 1
  type = number
}
*/

variable vpc_id {
  description = "VPC ID from which belogs the subnets"
  type        = string
}


variable eks_master_sg_id {
  description = "The security group id for the EKS master nodes"
  type        = string
}

variable eks_worker_node_groups_sg_id {
  description = "The security group id for the EKS worker nodes"
}

variable "keys" {
  
}

variable "values" {
  
}

variable "node_group_count" {
  
}

variable "scaling_config" {
    //  cidr_blocks  = list(string)
    type = list(object({
      min      = number
      desired  = number
      max      = number
    }))
}

variable "eks_worker_node_ssh_key" {
  
}

variable "remote_access_ssh_sg" {
  
}

variable "ami_id" {
  
}


variable "eks_version" {
  
}

variable "disk_types" {
  
}

variable "eks_cluster_worker_iam_role" {
  description = "cluster role name"
  default = "eks-node-group-ops"
}


variable "eks_cluster_iam_role" {
  description = "cluster role name"
  default = "eks_cluster_iam_role"
}