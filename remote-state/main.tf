resource "aws_dynamodb_table" "terraform-statelock" {
    name = "terraform-state-lock"
    hash_key = "value"
    read_capacity = 20
    write_capacity = 20

    attribute {
        name = "LockID"
        type = "S"
    }

    tags {
        Name = "Terraform state lock table"
        Deployment = var.deployment_name 
        Created_by = "Terraform"
    }
}

output "statelock_name" {
  value = aws_dynamodb_table.terraform-statelock.name
}




resource "aws_iam_role" "s3_remote_state_bucket_role" {
name = "remote-state-s3-role"
assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "aws_s3_remote_state_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = "${aws_iam_role.s3_remote_state_bucket_role.name}"
}

resource "aws_iam_role_policy_attachment" "aws_dynamodb_remote_state_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = "${aws_iam_role.s3_remote_state_bucket_role.name}"
}

