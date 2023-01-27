// Getting Subnet CIDRs based on the Subnet IDs
data "aws_subnet" "public_subnets" {
    for_each = toset(var.public_subnet_ids)
    id       = each.value
}

data "aws_subnet" "control_plane_subnets" {
    for_each = toset(var.control_plane_subnet_ids)
    id       = each.value
}

data "aws_subnet" "management_subnets" {
    for_each = toset(var.management_subnet_ids)
    id       = each.value
}

data "aws_subnet" "worker_nodes_one_subnets" {
    for_each = toset(var.worker_nodes_one_subnet_ids)
    id       = each.value
}


locals {
    public_subnet_cidrs = [
        for subnet in data.aws_subnet.public_subnets : subnet.cidr_block
    ]

    control_plane_subnet_cidrs = [
        for subnet in data.aws_subnet.control_plane_subnets : subnet.cidr_block
    ]

    management_subnet_cidrs = [
        for subnet in data.aws_subnet.management_subnets : subnet.cidr_block
    ]

    worker_nodes_one_subnet_cidrs = [
        for subnet in data.aws_subnet.worker_nodes_one_subnets : subnet.cidr_block
    ]

}