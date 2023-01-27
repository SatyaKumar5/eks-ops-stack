
output "aws_azs" {
  value = var.aws_azs
}

output "control_plane_zone_subnets_ids" {
  value = var.provision_control_plane_subnets == true ? aws_subnet.control_plane_zone_subnets.*.id : var.control_plane_subnet_ids
}

output "control_plane_zone_subnets_cidrs" {
  value = var.provision_control_plane_subnets == true ? aws_subnet.control_plane_zone_subnets.*.cidr_block : local.control_plane_subnet_cidrs
}

output "management_subnets_cidrs" {
  value = var.provision_control_plane_subnets == true ? aws_subnet.management_subnets.*.cidr_block : local.management_subnet_cidrs
}

output "management_subnets_ids" {
  value = var.provision_management_subnets == true ? aws_subnet.management_subnets.*.id : var.management_subnet_ids
}

output "worker_nodes_one_zone_subnets_cidrs" {
  value = var.provision_worker_nodes_one_subnets == true ? aws_subnet.worker_nodes_one_zone_subnets.*.cidr_block : local.worker_nodes_one_subnet_cidrs
}

output "worker_nodes_one_zone_subnets_ids" {
  value = var.provision_worker_nodes_one_subnets == true ? aws_subnet.worker_nodes_one_zone_subnets.*.id : var.worker_nodes_one_subnet_ids
}

output "public_subnets_ids" {
  value = var.provision_public_subnets == true ? aws_subnet.public_subnets.*.id : var.public_subnet_ids
}

output "public_subnets_cidrs" {
  value = var.provision_public_subnets == true ? aws_subnet.public_subnets.*.cidr_block : local.public_subnet_cidrs
}
