// Creates a new VPC
resource "aws_vpc" "default" {
  count = var.provision_vpc == true ? 1 : 0
  cidr_block           = "${var.vpc_cidr_base}${var.vpc_end_cidr}"
  instance_tenancy     = var.vpc_instance_tenancy
  enable_dns_support   = var.vpc_enable_dns_support
  enable_dns_hostnames = var.vpc_enable_dns_hostnames
  enable_classiclink   = var.vpc_enable_classiclink
  tags = merge(
    var.global_tags,
    {
      "Name" = var.aws_vpc_name
    },
  )
  lifecycle {
    ignore_changes = [tags]
    prevent_destroy = false
  }
}

/*

###################
# Flow Log
###################
resource "aws_flow_log" "this" {
  count = local.enable_flow_log ? 1 : 0

  log_destination_type     = var.flow_log_destination_type
  log_destination          = local.flow_log_destination_arn
  log_format               = var.flow_log_log_format
  iam_role_arn             = local.flow_log_iam_role_arn
  traffic_type             = var.flow_log_traffic_type
  vpc_id                   = local.vpc_id
  max_aggregation_interval = var.flow_log_max_aggregation_interval

  tags = merge(var.tags, var.vpc_flow_log_tags)
}

*/