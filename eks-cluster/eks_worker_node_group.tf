/*
resource "aws_launch_template" "worker_nodes_lt" {
  count       = var.node_group_count

  name        = "${var.eks_cluster_name}-lt-${element(var.node_group_names, count.index)}"
  description = "Worker Nodes launch Template for ${element(var.node_group_names, count.index)}"
 
  disable_api_termination = false
  ebs_optimized           = true
  image_id                = var.ami_id
  
  key_name                = var.eks_worker_node_ssh_key
  vpc_security_group_ids  = [var.eks_worker_node_groups_sg_id[count.index]]
  
  monitoring {
    enabled = true
  }  

  user_data = base64encode(<<-EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="
--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
/etc/eks/bootstrap.sh ${var.eks_cluster_name} --apiserver-endpoint ${aws_eks_cluster.main.endpoint} --b64-cluster-ca ${aws_eks_cluster.main.certificate_authority[0].data}
--==MYBOUNDARY==--\
  EOF
  )


  block_device_mappings {
    device_name = "/dev/xvda"
   
    ebs {
      volume_size = element(var.disk_sizes, count.index)
      volume_type = element(var.disk_types, count.index) 
      iops = 2000
      encrypted = true
    } 
  }

  depends_on = [ 
    aws_eks_cluster.main
  ]

  #defined
  instance_type           = element(var.instance_types, count.index)
}
*/


# Nodes in private subnets
resource "aws_eks_node_group" "main" {
  count           = var.node_group_count

  cluster_name    = var.eks_cluster_name

  node_group_name = var.node_group_names[count.index]
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.private_subnet_ids

  #ami_type       = var.ami_type
  #disk_size      = var.disk_sizes[count.index]
  #instance_types = [var.instance_types[count.index]]

  /*
  remote_access {
    ec2_ssh_key = var.eks_worker_node_ssh_key
    source_security_group_ids = var.remote_access_ssh_sg
  }
  */

  scaling_config {
    desired_size = var.scaling_config[count.index].desired
    max_size     = var.scaling_config[count.index].max
    min_size     = var.scaling_config[count.index].min
  }

  tags = {
      "${var.keys[format("key%d", count.index)]}" = "${var.values[format("value%d", count.index)]}",
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    }

  labels = {
      "${var.keys[format("key%d", count.index)]}" = "${var.values[format("value%d", count.index)]}",
    }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.aws_eks_worker_node_policy,
    aws_iam_role_policy_attachment.aws_eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_read_only,
    #aws_launch_template.worker_nodes_lt,
    aws_eks_cluster.main
  ]
}