resource "null_resource" "nat_gateway_ids_dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.nat_gateways_ids)}"
  }
}

resource "null_resource" "public_subnet_id_for_nat_dependency_setter" {
  depends_on = [
    "aws_subnet.public_subnets",
  ]
}


//----------------- Public Subnet Zone Configuration begins ---------------
// Creates Public Subnets
resource "aws_subnet" "public_subnets" {
  count             = var.provision_public_subnets ? "${length(var.public_subnet_cidrs)}" : 0
  vpc_id            = var.aws_vpc_id
  cidr_block        = "${var.vpc_cidr_base}${var.public_subnet_cidrs[format("zone%d", count.index)]}"
  availability_zone = element(var.aws_azs, count.index)    //element(split(", ", var.aws_azs), count.index)
  tags = merge(
    var.global_tags,
    {
      "Name" = "${var.public_subnet_name_tags[format("zone%d", count.index)]}"
    },
  )
}
//----------------- Public Subnet Zone Configuration ends ---------------




//----------------- Management Subnet Zone Configuration begins ---------------
// Creates Public Subnets
resource "aws_subnet" "management_subnets" {
  count             = var.provision_management_subnets ? "${length(var.management_subnet_cidrs)}" : 0
  vpc_id            = var.aws_vpc_id
  cidr_block        = "${var.vpc_cidr_base}${var.management_subnet_cidrs[format("zone%d", count.index)]}"
  availability_zone = element(var.aws_azs, count.index)    //element(split(", ", var.aws_azs), count.index)
  tags = merge(
    var.global_tags,
    {
      "Name" = "${var.management_subnet_name_tags[format("zone%d", count.index)]}"
    },
    //lookup(var.eks_internal_lb_tags, count.index, {}),
    //var.eks_internal_lb_tags
  )
}
//----------------- Management Subnet Zone Configuration ends ---------------



//----------------- Control Plane Zone Configuration begins ---------------
// Creates the app zone subnets
resource "aws_subnet" "control_plane_zone_subnets" {
  count             = var.provision_control_plane_subnets ? "${length(var.control_plane_zone_subnet_cidrs)}" : 0
  vpc_id            = var.aws_vpc_id
  cidr_block        = "${var.vpc_cidr_base}${var.control_plane_zone_subnet_cidrs[format("zone%d", count.index)]}"
  
  //count             = "${length(data.aws_availability_zones.azs.names)}"
 // cidr_block        = "${element(var.nwprivate_cidrs, count.index)}"

  availability_zone = element(var.aws_azs, count.index)  //element(split(", ", var.aws_azs), count.index)

  tags = merge(
    var.global_tags,
    {
      "Name" = "${var.control_plane_zone_subnet_name_tags[format("zone%d", count.index)]}"
    },
  )
  lifecycle {
    prevent_destroy = false
  }
}
//----------------- Control Plane Zone Configuration ends ---------------




//----------------- Worker Nodes One Zone Configuration begins ---------------
// Creates the worker zone one subnets
resource "aws_subnet" "worker_nodes_one_zone_subnets" {
  count             = var.provision_worker_nodes_one_subnets ? "${length(var.worker_nodes_one_subnet_cidrs)}" : 0
  vpc_id            = var.aws_vpc_id
  cidr_block        = "${var.vpc_cidr_base}${var.worker_nodes_one_subnet_cidrs[format("zone%d", count.index)]}"
  
  //count             = "${length(data.aws_availability_zones.azs.names)}"
 // cidr_block        = "${element(var.nwprivate_cidrs, count.index)}"

  availability_zone = element(var.aws_azs, count.index)   //element(split(", ", var.aws_azs), count.index)

  tags = merge(
    var.global_tags,
    {
      "Name" = "${var.worker_nodes_one_subnet_name_tags[format("zone%d", count.index)]}"
    },
    //lookup(var.eks_worker_node_tags, count.index, {}),
    var.eks_worker_node_tags
  )
}
//----------------- Worker Nodes One Zone Configuration ends ---------------