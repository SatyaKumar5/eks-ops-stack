# EKS Cluster Terraform
This is a project that demonstrates how to use Terraform to provision EKS on AWS.

## Description
You've joined a new and growing startup.
The company wants to build its initial Kubernetes infrastructure on AWS.
They have asked you if you can help create the following:
- Terraform code that deploys an EKS cluster (whatever latest version is currently available) into an existing VPC
- The terraform code should also prepare anything needed for a pod to be able to assume an IAM role
- Include a short readme that explains how to use the Terraform repo and that also demonstrates how an end-user (a developer from the company) can run a pod on this new EKS cluster and also have an IAM role assigned that allows that pod to access an S3 bucket.

## Prerequisites
- Terraform
- AWS account and access to the AWS CLI
- AWS CLI must be configured with access keys
- AWS CLI profile must be passed as input to the terraform

## Getting Started
- Clone the repository: https://github.com/SatyaKumar5/eks-ops-stack.git
- Change into the project directory: cd Opsfleet-stack
- Update the locals.tf file with the neccessary details
- Run `terraform init` to download the required modules.
- Run `terraform plan` to see what changes will be made.
- If the plan looks good, run `terraform apply` to create the infrastructure.
- Run `terraform destroy` when you're done and want to delete the resources.

## Access S3 from pod in kubernetes
- After the EKS cluster is created, configure `kubectl`
    ```sh aws eks update-kubeconfig --name <cluster_name> ```
- Verify the cluster is up and running
```sh kubectl get nodes```

    ``` yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: my-s3-pod
    spec:
      containers:
      - name: my-s3-container
        image: amazon/aws-cli:latest
        command: ["sh", "-c", "aws s3 ls s3://opsfleet-test-bucket"] 
    ```
    
    This is a Kubernetes YAML configuration file that defines a Pod resource named "my-s3-pod". The Pod has one container named "my-s3-container" that runs the Amazon Web Services (AWS) command line interface (CLI) image. The container runs the command "aws s3 ls s3://opsfleet-test-bucket" which lists the contents of an S3 bucket named "opsfleet-test-bucket" using the AWS CLI.
    
## Modules
This project contains the following modules:
- VPC
- Security Group
- EKS

## Notes
- The provision_vpc variable is set to true by default, which will provision a new VPC. If you have an existing VPC and don't want to provision a new one, set this variable to false and add the existing VPC ID to existing_vpc_id variable.
- The aws_profile_name variable should be set to the name of the AWS CLI profile you want to use. This profile must have the necessary permissions to create the resources in this project.
- The resource_prefix variable is used to prefix all the resource names, so they are easily identifiable in the AWS console.

## Additional Notes

- The "eks-cluster" module contains the main Terraform code for creating the EKS cluster, including the definition of the cluster, worker nodes, and various policies.
- The "jump-box" module creates a jump box, which is used to access the EKS cluster.
- The "Opsfleet-stack" is the main module of the project, and includes the backend, data, key-pairs, locals, and variables that are used to configure the EKS cluster.
- The "remote-state", "s3", "security-group", "subnets", and "vpc" modules are used to create other infrastructure components such as remote state, S3 bucket, security group, subnets and VPC required for EKS.
