output "public_ip" {
  description = "Public IP Address of the instance"
  value       = join("", aws_instance.jump-box[*].public_ip)
}

output "instance_id" {
  description = "The id of the instance"
  value       = join("", aws_instance.jump-box[*].id)
}

