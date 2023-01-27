output "aws_vpc_id" {
  value = length(aws_vpc.default) > 0 ? aws_vpc.default[0].id : ""
}

output "aws_vpc_cidr" {
  value = length(aws_vpc.default) > 0 ? aws_vpc.default[0].cidr_block : ""
}

output "az_count" {
  value = var.az_count
}
