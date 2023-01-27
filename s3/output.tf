output "s3_bucket_ids" {
  value = aws_s3_bucket.s3_bucket.*.id
}

output "s3_bucket_arns" {
  value = aws_s3_bucket.s3_bucket.*.arn
}