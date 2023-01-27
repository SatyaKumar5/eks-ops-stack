resource "aws_s3_bucket" "s3_bucket" {
  count = length(var.s3_bucket_name)
  bucket = element(var.s3_bucket_name, count.index)
  acl    = "private"

  versioning {
    enabled = element(var.s3_versioning_enabled, count.index) #true
  }

  lifecycle {
    prevent_destroy = false
  }

}