provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  region                  = local.region
  profile                 = local.aws_profile_name
}

module "vpc" {
  source        = "./../vpc"
  provision_vpc = local.provision_vpc

  aws_vpc_name = "${local.resource_prefix}-primary-vpc"

  az_count = local.az_count

  vpc_cidr_base            = local.vpc_cidr_base
  vpc_end_cidr             = local.vpc_end_cidr
  vpc_instance_tenancy     = "default"
  vpc_enable_dns_support   = "true"
  vpc_enable_dns_hostnames = "true"
  vpc_enable_classiclink   = "false"

  global_tags = local.global_tags
}

module "security-group" {
  source = "./../security-group"

  aws_vpc_id                       = local.provision_vpc == true ? module.vpc.aws_vpc_id : local.existing_vpc_id

  external_jump_box_sg_name        = "${local.resource_prefix}-external-jumpbox-sg"
  external_jump_box_sg_description = "Security Group for JumpBox"
  external_jump_box_sg_tags = {
    Name = "${local.name_tag_prefix} External JumpBox SG"
  }
  external_jump_box_ingress_rules = [
    {
      from_port   = 37689
      to_port     = 37689
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allows everyone to connect with the External JumpBox"
    },
  ]
  external_jump_box_egress_rules = [
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      source_security_group_id = "${module.security-group.eks_worker_node_groups_one_sg_id}"
      description              = "Allows external jumpBox to SSH into EKS Generic Compute Worker Nodes"
    },
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      source_security_group_id = "${module.security-group.eks_master_sg_id}"
      description              = "Allows external jumpBox to connect to EKS"
    } 
  ]
  external_jump_box_cidr_egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allows all the resources to talk to VPCE"
    },    
  ]


  eks_master_sg_name        = "${local.resource_prefix}-eks-master-sg"
  eks_master_sg_description = "Cluster communication with worker nodes"
  eks_master_sg_tags = {
    "Name" = "${local.name_tag_prefix} EKS Master SG"
  }
  eks_master_ingress_rules = [
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      source_security_group_id = "${module.security-group.external_jumpbox_sg_id}"
      description              = "Allow External Jump Box to communicate with the Master"
    },    
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      source_security_group_id = "${module.security-group.eks_worker_node_groups_one_sg_id}"
      description              = "Allow EKS Generic Compute Worker Nodes to communicate with the Master"
    },
    {
      from_port                = 0
      to_port                  = 65535
      protocol                 = "tcp"
      source_security_group_id = "${module.security-group.eks_worker_node_groups_one_sg_id}"
      description              = "Allow EKS Generic Compute Worker Nodes to communicate with the Master"
    },
    {
      from_port                = 10250
      to_port                  = 10250
      protocol                 = "tcp"
      source_security_group_id = "${module.security-group.eks_master_sg_id}"
      description              = "Mininum Requirement"
    },
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      source_security_group_id = "${module.security-group.eks_master_sg_id}"
      description              = "Mininum Requirement"
    },
  ]
  eks_master_egress_rules = [
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      source_security_group_id = "${module.security-group.eks_master_sg_id}"
      description              = "Minimum Requirement"
    },
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      source_security_group_id = "${module.security-group.eks_worker_node_groups_one_sg_id}"
      description              = "Allow EKS Master Nodes to communicate with the EKS Generic Compute Worker Nodes"
    },
    {
      from_port                = 1024
      to_port                  = 65535
      protocol                 = "tcp"
      source_security_group_id = "${module.security-group.eks_master_sg_id}"
      description              = "Allow EKS Master Nodes to communicate with the cluster API Server"
    },
    {
      from_port                = 1024
      to_port                  = 65535
      protocol                 = "tcp"
      source_security_group_id = "${module.security-group.eks_worker_node_groups_one_sg_id}"
      description              = "Allow EKS Master Nodes to communicate with the EKS Generic Compute Worker Nodes"
    }
  ]
  eks_cluster_name = local.cluster_name


  //-------- Security group configuration for EKS WORKER LT NODES Begin -------------------------  
  eks_worker_node_groups_one_sg_names       = "${local.resource_prefix}-generic-compute-sg"

  eks_worker_node_groups_one_sg_description = "Security group for generic compute nodes in the cluster"

  eks_worker_node_groups_one_sg_tags = {
      "Name" = "${local.name_tag_prefix} EKS Generic Compute Target Group SG"
  }

  eks_worker_node_groups_one_ingress_rules = [
    // Generic Compute Worker Nodes INGRESS Security Group Rules 
      {
        from_port                = 0
        to_port                  = 0
        protocol                 = "-1"
        source_security_group_id = "${module.security-group.eks_worker_node_groups_one_sg_id}"
        description              = "Recommended"
      },
      {
        from_port                = 0
        to_port                  = 0
        protocol                 = "-1"
        source_security_group_id = "${module.security-group.eks_master_sg_id}"
        description              = "Recommended"
      },
      {
        from_port                = 22
        to_port                  = 22
        protocol                 = "tcp"
        source_security_group_id = "${module.security-group.external_jumpbox_sg_id}"
        description              = "Allow Internal Jump Box to communicate with the Generic Compute Worker Nodes"
      }
    ]

  
  eks_worker_node_groups_one_egress_rules = [
    // Generic Compute Worker Nodes EGRESS Security Group Rules
      {
        from_port                = 443
        to_port                  = 443
        protocol                 = "tcp"
        source_security_group_id = "${module.security-group.eks_master_sg_id}"
        description              = "Allow Generic Compute Worker Nodes to communicate with the EKS Master Nodes"
      },
      {
        from_port                = 443
        to_port                  = 443
        protocol                 = "tcp"
        source_security_group_id = "${module.security-group.eks_worker_node_groups_one_sg_id}"
        description              = "Allow Generic Compute Worker Nodes to communicate with the EKS Generic Compute Worker Nodes"
      },
      {
        from_port                = 8443
        to_port                  = 8443
        protocol                 = "tcp"
        source_security_group_id = "${module.security-group.eks_worker_node_groups_one_sg_id}"
        description              = "Allow Generic Compute Worker Nodes to communicate with the EKS Generic Compute Worker Nodes"
      }
    ]
  

  eks_worker_node_groups_one_cidr_egress_rules = [
      
    ]

 //-------- Security group configuration for EKS WORKER LT NODES Ends -------------------------

module "jump-box" {
  source                      = "./../jump-box"
  resource_prefix             = local.resource_prefix
  aws_vpc_id                  = local.provision_vpc == true ? module.vpc.aws_vpc_id : local.existing_vpc_id
  subnet_ids                  = local.existing_public_subnet_ids
  instance_count              = local.jumpbox_instance_count
  instance_tags               = local.jumpbox_instance_tags
  volume_type                 = local.jumpbox_volume_types
  volume_size                 = local.jumpbox_volume_size
  ami_id                      = local.jumpbox_ami_id
  instance_type               = local.jumpbox_instance_type
  termination_protection      = local.jumpbox_termination_protection
  key_pair                    = "${local.resource_prefix}-eks-worker-node-key"
  jumpbox_associate_public_ip = local.jumpbox_associate_public_ip
  jumpbox_enable_instances_monitoring = local.jumpbox_enable_instances_monitoring
  jumpbox_sg_id               = ["${module.security-group.external_jumpbox_sg_id}"]
}


module "s3" {
  source         = "./../s3"
  s3_bucket_name = local.s3_bucket_name
  aws_region     = local.region
  #kms_key_arn    = [module.kms.arn[4], module.kms.arn[5]]
  s3_versioning_enabled = local.s3_versioning_enabled
}


module "eks_cluster_and_worker_nodes" {
  source = "./../eks-cluster"
  # Cluster
  vpc_id = local.provision_vpc == true ? module.vpc.aws_vpc_id : local.existing_vpc_id

  eks_cluster_name = local.cluster_name
  eks_version      = local.eks_version
  eks_master_sg_id = module.security-group.eks_master_sg_id
  eks_worker_node_groups_sg_id = [module.security-group.eks_worker_node_groups_one_sg_id]
  // BELOW: # module.subnets_for_eks.private subnet ids
  eks_cluster_subnet_ids = local.control_plane_subnet_ids

  endpoint_private_access = local.eks_endpoint_private_access
  endpoint_public_access  = local.eks_endpoint_public_access

  // Put the KMS Key for Encrypting the SECRETS
 # kms_key_arn_for_encrypting_k8s_secrets  = module.kms.arn[3]
 # kms_key_arn_for_encrypting_worker_nodes = module.kms.arn[2]

  # Node group
  node_group_count = local.eks_node_group_count
  node_group_names = local.eks_node_group_names
  instance_types   = local.eks_instance_types

  #    Logic: Remote accessing to worker nodes
  #    If enable_eks_worker_nodes_ssh is set to true, key & security group is passed
  #    If enable_eks_worker_nodes_ssh is set to false, "" & [] is passed

  eks_worker_node_ssh_key = ("${local.enable_eks_worker_nodes_ssh}" == true) ? "${local.resource_prefix}-eks-worker-node-key" : ""
  remote_access_ssh_sg    = ("${local.enable_eks_worker_nodes_ssh}" == true) ? [module.security-group.eks_worker_node_groups_one_sg_id] : []

  #ami_id         = data.aws_ami.latest-ubuntu.id #"ami-0652e1dffe1f674e2"    
  ami_id         = "ami-06c9b6a12f5bd0a96"
  disk_sizes     = local.eks_disk_sizes
  disk_types     = local.eks_disk_types
  keys           = local.eks_node_group_label_keys
  values         = local.eks_node_group_label_values
  scaling_config = local.eks_node_group_scaling_config

  private_subnet_ids = local.worker_nodes_one_subnet_ids
  environment        = local.environment
}
