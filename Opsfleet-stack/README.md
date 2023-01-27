Prerequisites
Terraform
AWS account and access to the AWS CLI
AWS CLI must be configured with access keys
AWS CLI profile must be passed as input to the terraform
Getting Started
Clone the repository: git clone https://github.com/<username>/my-project.git
Change into the project directory: cd my-project
Create a file named terraform.tfvars and add the following variables:
Copy code
aws_profile_name = "my-aws-cli-profile"
resource_prefix = "my-project"
region = "us-west-2"
az_count = "3"
vpc_cidr_base = "10.0.0.0"
vpc_end_cidr = "10.0.3.0"
provision_vpc = true
Run terraform init to download the required modules.
Run terraform plan to see what changes will be made.
If the plan looks good, run terraform apply to create the infrastructure.
Run terraform destroy when you're done and want to delete the resources.
Modules
This project contains the following modules:

VPC
Security Group
EKS
Notes
The provision_vpc variable is set to true by default, which will provision a new VPC. If you have an existing VPC and don't want to provision a new one, set this variable to false and add the existing VPC ID to existing_vpc_id variable.
The aws_profile_name variable should be set to the name of the AWS CLI profile you want to use. This profile must have the necessary permissions to create the resources in this project.
The resource_prefix variable is used to prefix all the resource names, so they are easily identifiable in the AWS console.
Support
If you have any issues or questions, please reach out to me at <email>