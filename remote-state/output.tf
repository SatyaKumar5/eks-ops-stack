output "s3_remote_bucket_access_role" {
    value = aws_iam_role.s3_remote_state_bucket_role.arn
}