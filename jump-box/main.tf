resource "null_resource" "jumpbox_sg_dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.jumpbox_sg_id)}"
  }
}

resource "null_resource" "kms_key_arn_dependency_getter" {
  provisioner "local-exec" {
    command = "echo ${length(var.kms_key_arn)}"
  }
}

locals {
  user_data = [base64encode(templatefile("${path.module}/external-jump-box-user-data.sh", {}))]
}


# Jumpbox instance for creating a private EKS cluster 
resource "aws_instance" "jump-box" {
  ami           = var.ami_id
  instance_type = var.instance_type
  // security_groups             = ["${element(var.jumpbox_sg_id, count.index)}"]
  vpc_security_group_ids      = ["${element(var.jumpbox_sg_id, count.index)}"]
  associate_public_ip_address = element(var.jumpbox_associate_public_ip, count.index)
  subnet_id                   = element(var.subnet_ids, count.index)
  disable_api_termination     = var.termination_protection
  count                       = var.instance_count
  monitoring                  = var.jumpbox_enable_instances_monitoring

  // Uses the existing SSH key
  key_name = var.key_pair

  root_block_device {
    volume_type = var.volume_type
    volume_size = var.volume_size
    encrypted   = true
  }

  lifecycle {
    prevent_destroy = false
  }

  depends_on = ["null_resource.kms_key_arn_dependency_getter"]

  user_data_base64 = element(local.user_data, count.index)

  tags = {
    "Name" = "${element(var.instance_tags, count.index)}"
  }
}




