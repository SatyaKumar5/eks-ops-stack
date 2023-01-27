//-------- Security group configuration for EKS MASTER NODES Begin -------------------------
resource "aws_security_group" "eks_cluster" {
  name        = var.eks_master_sg_name
  description = var.eks_master_sg_description
  vpc_id      = var.aws_vpc_id

  tags = var.eks_master_sg_tags
}


resource "aws_security_group_rule" "cluster_inbound" {
  count                    = length(var.eks_master_ingress_rules)
  type                     = "ingress"
  from_port                = var.eks_master_ingress_rules[count.index].from_port
  to_port                  = var.eks_master_ingress_rules[count.index].to_port
  protocol                 = var.eks_master_ingress_rules[count.index].protocol
  source_security_group_id = var.eks_master_ingress_rules[count.index].source_security_group_id
  description              = var.eks_master_ingress_rules[count.index].description
  security_group_id        = aws_security_group.eks_cluster.id
}


resource "aws_security_group_rule" "cluster_outbound" {
  count                    = length(var.eks_master_egress_rules)
  type                     = "egress"
  from_port                = var.eks_master_egress_rules[count.index].from_port
  to_port                  = var.eks_master_egress_rules[count.index].to_port
  protocol                 = var.eks_master_egress_rules[count.index].protocol
  source_security_group_id = var.eks_master_egress_rules[count.index].source_security_group_id
  description              = var.eks_master_egress_rules[count.index].description
  security_group_id        = aws_security_group.eks_cluster.id
}


resource "null_resource" "eks_master_sg_dependency_setter" {
  depends_on = [
    "aws_security_group.eks_cluster",
  ]
}
//-------- Security group configuration for EKS MASTER NODES Ends -------------------------




//-------- Security group configuration for EKS WORKER LT NODES Begin -------------------------
resource "aws_security_group" "eks_worker_node_groups_one" {
  name        = var.eks_worker_node_groups_one_sg_names
  description = var.eks_worker_node_groups_one_sg_description
  vpc_id      = var.aws_vpc_id

  tags = merge(
    var.eks_worker_node_groups_one_sg_tags,
    {
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    }
  )
}


resource "aws_security_group_rule" "eks_worker_node_groups_one_ingress_rules" {
  count                    = length(var.eks_worker_node_groups_one_ingress_rules)
  type                     = "ingress"
  from_port                = var.eks_worker_node_groups_one_ingress_rules[count.index].from_port
  to_port                  = var.eks_worker_node_groups_one_ingress_rules[count.index].to_port
  protocol                 = var.eks_worker_node_groups_one_ingress_rules[count.index].protocol
  source_security_group_id = var.eks_worker_node_groups_one_ingress_rules[count.index].source_security_group_id
  description              = var.eks_worker_node_groups_one_ingress_rules[count.index].description
  security_group_id        = aws_security_group.eks_worker_node_groups_one.id
}


resource "aws_security_group_rule" "eks_worker_node_groups_one_egress_rules" {
  count                    = length(var.eks_worker_node_groups_one_egress_rules)
  type                     = "egress"
  from_port                = var.eks_worker_node_groups_one_egress_rules[count.index].from_port
  to_port                  = var.eks_worker_node_groups_one_egress_rules[count.index].to_port
  protocol                 = var.eks_worker_node_groups_one_egress_rules[count.index].protocol
  source_security_group_id = var.eks_worker_node_groups_one_egress_rules[count.index].source_security_group_id
  description              = var.eks_worker_node_groups_one_egress_rules[count.index].description
  security_group_id        = aws_security_group.eks_worker_node_groups_one.id
}

resource "aws_security_group_rule" "eks_worker_node_groups_one_cidr_egress_rules" {
  count             = length(var.eks_worker_node_groups_one_cidr_egress_rules)
  type              = "egress"
  from_port         = var.eks_worker_node_groups_one_cidr_egress_rules[count.index].from_port
  to_port           = var.eks_worker_node_groups_one_cidr_egress_rules[count.index].to_port
  protocol          = var.eks_worker_node_groups_one_cidr_egress_rules[count.index].protocol
  cidr_blocks       = var.eks_worker_node_groups_one_cidr_egress_rules[count.index].cidr_blocks
  description       = var.eks_worker_node_groups_one_cidr_egress_rules[count.index].description
  security_group_id = aws_security_group.eks_worker_node_groups_one.id
}


resource "null_resource" "eks_worker_node_groups_one_sg_dependency_setter" {
  depends_on = [
    "aws_security_group.eks_worker_node_groups_one",
  ]
}

//-------- Security group configuration for EKS WORKER LT NODES Ends -------------------------



/*
//-------- Security group configuration for EKS WORKER NODES Begin -------------------------
resource "aws_security_group" "eks_nodes" {
  name        = var.eks_worker_sg_name
  description = var.eks_worker_sg_description
  vpc_id      = "${var.aws_vpc_id}"

  tags = merge(
    var.eks_worker_sg_tags,
    {
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    }
  ) 
}



resource "aws_security_group_rule" "more_nodes_inbound_rules" {
  count             = length(var.eks_worker_ingress_rules)
  type              = "ingress"
  from_port         = var.eks_worker_ingress_rules[count.index].from_port
  to_port           = var.eks_worker_ingress_rules[count.index].to_port
  protocol          = var.eks_worker_ingress_rules[count.index].protocol
  source_security_group_id       = var.eks_worker_ingress_rules[count.index].source_security_group_id
  description       = var.eks_worker_ingress_rules[count.index].description
  security_group_id = aws_security_group.eks_nodes.id
}


resource "aws_security_group_rule" "nodes_outbound" {
  count             = length(var.eks_worker_egress_rules)
  type              = "egress"
  from_port         = var.eks_worker_egress_rules[count.index].from_port
  to_port           = var.eks_worker_egress_rules[count.index].to_port
  protocol          = var.eks_worker_egress_rules[count.index].protocol
  source_security_group_id       = var.eks_worker_egress_rules[count.index].source_security_group_id
  description       = var.eks_worker_egress_rules[count.index].description
  security_group_id = aws_security_group.eks_nodes.id
}

resource "aws_security_group_rule" "nodes_cidr_outbound" {
  count             = length(var.eks_worker_cidr_egress_rules)
  type              = "egress"
  from_port         = var.eks_worker_cidr_egress_rules[count.index].from_port
  to_port           = var.eks_worker_cidr_egress_rules[count.index].to_port
  protocol          = var.eks_worker_cidr_egress_rules[count.index].protocol
  cidr_blocks       = var.eks_worker_cidr_egress_rules[count.index].cidr_blocks
  description       = var.eks_worker_cidr_egress_rules[count.index].description
  security_group_id = aws_security_group.eks_nodes.id
}


resource "null_resource" "eks_worker_sg_dependency_setter" {
  depends_on = [
    "aws_security_group.eks_nodes",
  ]
}
//-------- Security group configuration for EKS WORKER NODES Ends -------------------------
*/


//-------- Security group configuration for VPCE Begin -------------------------
resource "aws_security_group" "vpce_sg" {
  vpc_id      = var.aws_vpc_id
  name        = var.vpce_sg_name
  description = var.vpce_sg_description

  tags = var.vpce_sg_tags

  lifecycle {
    prevent_destroy = false
  }
}

// Added CIDR inbound
resource "aws_security_group_rule" "vpce_cidr_inbound" {
  count       = length(var.vpce_cidr_ingress_rules)
  type        = "ingress"
  from_port   = var.vpce_cidr_ingress_rules[count.index].from_port
  to_port     = var.vpce_cidr_ingress_rules[count.index].to_port
  protocol    = var.vpce_cidr_ingress_rules[count.index].protocol
  cidr_blocks = var.vpce_cidr_ingress_rules[count.index].cidr_blocks

  //source_security_group_id       = var.eks_master_cidr_ingress_rules[count.index].source_security_group_id
  description       = var.vpce_cidr_ingress_rules[count.index].description
  security_group_id = aws_security_group.vpce_sg.id
}
//

resource "aws_security_group_rule" "vpce_ingress_rules" {
  count                    = length(var.vpce_ingress_rules)
  type                     = "ingress"
  from_port                = var.vpce_ingress_rules[count.index].from_port
  to_port                  = var.vpce_ingress_rules[count.index].to_port
  protocol                 = var.vpce_ingress_rules[count.index].protocol
  source_security_group_id = var.vpce_ingress_rules[count.index].source_security_group_id
  description              = var.vpce_ingress_rules[count.index].description
  security_group_id        = aws_security_group.vpce_sg.id
}


resource "aws_security_group_rule" "vpce_egress_rules" {
  count                    = length(var.vpce_egress_rules)
  type                     = "egress"
  from_port                = var.vpce_egress_rules[count.index].from_port
  to_port                  = var.vpce_egress_rules[count.index].to_port
  protocol                 = var.vpce_egress_rules[count.index].protocol
  source_security_group_id = var.vpce_egress_rules[count.index].source_security_group_id
  description              = var.vpce_egress_rules[count.index].description
  security_group_id        = aws_security_group.vpce_sg.id
}

resource "null_resource" "vpce_sg_dependency_setter" {
  depends_on = [
    "aws_security_group.vpce_sg",
  ]
}
//-------- Security group configuration for VPCE Ends -------------------------

//-------- Security group configuration for Jump Box Begin -------------------------
resource "aws_security_group" "external_jumpbox_sg" {
  vpc_id      = var.aws_vpc_id
  name        = var.external_jump_box_sg_name
  description = var.external_jump_box_sg_description

  tags = var.external_jump_box_sg_tags

  lifecycle {
    prevent_destroy = false
  }
}


resource "aws_security_group_rule" "external_jumpbox_ingress_rules" {
  count     = length(var.external_jump_box_ingress_rules)
  type      = "ingress"
  from_port = var.external_jump_box_ingress_rules[count.index].from_port
  to_port   = var.external_jump_box_ingress_rules[count.index].to_port
  protocol  = var.external_jump_box_ingress_rules[count.index].protocol

  cidr_blocks = var.external_jump_box_ingress_rules[count.index].cidr_blocks

  //source_security_group_id       = var.jump_box_ingress_rules[count.index].source_security_group_id
  description       = var.external_jump_box_ingress_rules[count.index].description
  security_group_id = aws_security_group.external_jumpbox_sg.id
}


resource "aws_security_group_rule" "external_jumpbox_egress_rules" {
  count                    = length(var.external_jump_box_egress_rules)
  type                     = "egress"
  from_port                = var.external_jump_box_egress_rules[count.index].from_port
  to_port                  = var.external_jump_box_egress_rules[count.index].to_port
  protocol                 = var.external_jump_box_egress_rules[count.index].protocol
  source_security_group_id = var.external_jump_box_egress_rules[count.index].source_security_group_id
  description              = var.external_jump_box_egress_rules[count.index].description
  security_group_id        = aws_security_group.external_jumpbox_sg.id
}


resource "aws_security_group_rule" "external_jump_box_cidr_egress_rules" {
  count             = length(var.external_jump_box_cidr_egress_rules)
  type              = "egress"
  from_port         = var.external_jump_box_cidr_egress_rules[count.index].from_port
  to_port           = var.external_jump_box_cidr_egress_rules[count.index].to_port
  protocol          = var.external_jump_box_cidr_egress_rules[count.index].protocol
  cidr_blocks       = var.external_jump_box_cidr_egress_rules[count.index].cidr_blocks
  description       = var.external_jump_box_cidr_egress_rules[count.index].description
  security_group_id = aws_security_group.external_jumpbox_sg.id
}

resource "null_resource" "jumpbox_sg_dependency_setter" {
  depends_on = [
    "aws_security_group.external_jumpbox_sg",
  ]
}
//-------- Security group configuration for Jump Box Ends -------------------------