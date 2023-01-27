locals {
  /* AWS PROFILE CONFIG STARTS */
  aws_profile_name = "default"
  region           = "us-east-1"
  az_count         = "1"
  az_tags = {
    zone0 = "A"
  }
  /* AWS PROFILE CONFIG ENDS */


  /* STACK CONFIGURATIONS STARTS */
  resource_prefix = "opsfleet"
  cluster_name    = "dev"
  name_tag_prefix = "opsfleet"
  environment     = "DEV"
  global_tags = {
    "Stack"      = "${local.resource_prefix}-stack"
    "Managed By" = "terraform"
  }

  s3_bucket_name = ["${local.resource_prefix}-stack-s3-state-bucket"]
  s3_versioning_enabled = [true, true, true]
  s3_vpce_flow_log_index = 0
  s3_squid_proxy_bucket_index = 1
  s3_state_file_bucket_index = 2
  /* STACK CONFIGURATIONS ENDS */


  /* VPC CONFIG STARTS */
  provision_vpc = false
  vpc_cidr_base = "10.6"
  vpc_end_cidr  = ".0.0/16"
  # Note: If you set provision_vpc to false, than you can specify the existing VPC ID using below parameter
  existing_vpc_id = "vpc-09385aecb3a5db178"

  enable_vpc_flow_log = false
  /* VPC CONFIG ENDS */

  existing_public_subnet_ids = ["subnet-07be1d69595fa9258"]

  provision_public_subnets             = false
  provision_control_plane_subnets      = false
  provision_worker_nodes_one_subnets   = false



  # USE DATA TO IMPORT THE ROUTE TABLE ID
  // EKSControlPlaneSubnetZoneX
  control_plane_subnet_ids = ["subnet-0bbbc646a2edf932e", "subnet-0b66f353bc78e139c"]
  // EKSWorker1SubnetZoneX
  worker_nodes_one_subnet_ids = ["subnet-0bbbc646a2edf932e", "subnet-0b66f353bc78e139c"]


  provision_route_table_public_subnets             = false
  provision_route_table_dmz_subnets                = false
  provision_route_table_management_subnets         = false
  provision_route_table_worker_nodes_one_subnets   = true
  provision_route_table_control_plane_zone_subnets = true


  ///// NEWLY ADDED
  public_route_table_name             = "PublicSubnetRouteTable"
  control_plane_zone_route_table_name = "EKSControlPlaneSubnetRouteTable"
  management_route_table_name         = "ManagementSubnetRouteTable"
  worker_nodes_one_route_table_name   = "EKSWorker1SubnetRouteTable"
  ///////

  // Toggle to associate NAT Gateways 
  associate_nat_with_worker_nodes_one_subnets   = false


  /* JUMP BOX CONFIG STARTS */
  jumpbox_instance_count              = "1"
  jumpbox_instance_tags               = ["${local.resource_prefix}-jump-box"]
  jumpbox_volume_types                = "gp2"
  jumpbox_volume_size                 = 30
  jumpbox_ami_id                      = data.aws_ami.latest-ubuntu.id
  jumpbox_instance_type               = "t2.micro"
  jumpbox_associate_public_ip         = [true]
  jumpbox_termination_protection      = true
  jumpbox_enable_instances_monitoring = true
  /* JUMP BOX CONFIG ENDS */


  
  /* EKS CONFIG STARTS */
  enable_eks_worker_nodes_ssh = true

  eks_endpoint_private_access = true
  eks_endpoint_public_access  = false
  eks_node_group_count        = 1
  eks_version                 = "1.24"
  eks_node_group_names        = ["generic-compute"]
  eks_instance_types          = ["t3.medium"]
  eks_disk_sizes              = [64, 64, 64]
  eks_disk_types              = ["io1", "io1", "io1"]
  eks_node_group_label_keys = {
    "key0" = "node-type"
  }
  eks_node_group_label_values = {
    "value0" = "generic-compute"
  }
  eks_node_group_scaling_config = [
    {
      min     = 1,
      desired = 1,
      max     = 2
    }
  ]
  /* EKS CONFIG ENDS */
}
