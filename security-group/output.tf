output "eks_master_sg_id" {
  value = aws_security_group.eks_cluster.id
}

/*
output "eks_worker_sg_id" {
  value = aws_security_group.eks_nodes.id
}
*/

output "vpce_sg_id" {
  value = aws_security_group.vpce_sg.id
}

output "eks_worker_node_groups_one_sg_id" {
  value = aws_security_group.eks_worker_node_groups_one.id
}

output "external_jumpbox_sg_id" {
  value = aws_security_group.external_jumpbox_sg.id
}
