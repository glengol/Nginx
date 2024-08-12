# Terraform NGINX Deployment on AWS

This project contains Terraform configurations to automate the deployment of an NGINX web server on AWS. The infrastructure is designed using a combination of public and private subnets, providing a secure and scalable environment. The deployment includes two key EC2 instances: a **bastion host** in a public subnet and an **NGINX server** running in a Docker container within a private subnet. The bastion host serves as an intermediary, securely proxying HTTP traffic from the public internet to the NGINX server in the private subnet.

## Overview of the Infrastructure

### VPC (Virtual Private Cloud)
The infrastructure is built within an AWS VPC, which provides an isolated network environment. The VPC is configured with both public and private subnets:

- **Public Subnets**: These subnets are accessible from the internet via an Internet Gateway (IGW). The bastion host, which allows SSH access and serves as a proxy, resides in one of these subnets.
  
- **Private Subnets**: These subnets are not directly accessible from the internet. The NGINX server, running inside a Docker container, is deployed in a private subnet to enhance security. It can only be accessed via the bastion host or through internal network routing.

### Security Groups
Security groups are defined to control inbound and outbound traffic to the instances:

- **Bastion Host Security Group**: Allows inbound SSH traffic from a specified IP range (for administrative access) and HTTP traffic for proxying to the NGINX server.
  
- **NGINX Server Security Group**: Restricts inbound traffic to only allow HTTP traffic from the bastion host, ensuring that the NGINX server is not directly exposed to the internet.

### EC2 Instances
Two EC2 instances are launched:

1. **Bastion Host**:
   - Deployed in the public subnet.
   - Facilitates secure SSH access to the private subnet.
   - Proxies HTTP traffic to the NGINX server.

2. **NGINX Server**:
   - Deployed in the private subnet.
   - Runs the NGINX web server inside a Docker container.
   - Configured using a custom Docker image (`glengold/nginx:latest`).

### Orchestration
Terraform is used to orchestrate the entire infrastructure deployment. Terraform configurations ensure that all components are correctly provisioned, networked, and secured. The goal is to create a seamless, one-command deployment process that can be repeated or modified easily.

## Files and Directories

### 1. `main.tf`
This is the primary Terraform configuration file where the AWS provider is set up, and the VPC module is included. The VPC module handles the creation of the network infrastructure, including public and private subnets, routing tables, and an Internet Gateway (IGW).

### 2. `variables.tf`
This file defines the input variables used across the Terraform project. These include:

- **AWS Region**: The geographical region where the infrastructure will be deployed (e.g., `us-east-1`).
- **AMI IDs**: The Amazon Machine Images used for the EC2 instances.
- **Instance Names**: Descriptive names for the bastion host and NGINX server.
- **VPC and Subnet CIDRs**: IP address ranges for the VPC and its subnets.
- **Availability Zones**: Specific availability zones where the subnets are deployed.

### 3. `instances.tf`
This file defines the EC2 instances for both the bastion host and the NGINX server. It includes:

- **Instance Types**: The type and size of the EC2 instances.
- **Key Pairs**: The SSH key pair used for accessing the instances.
- **User Data**: Scripts to configure the instances on launch, such as installing Docker on the NGINX server and starting the NGINX container.

### 4. `sg.tf`
This file configures the security groups:

- **allow_http_sg**: Permits HTTP traffic to the bastion host from any source.
- **allow_bastion_sg**: Allows traffic between the bastion host and the NGINX server, ensuring the server is only accessible through the bastion host.

### 5. `auto.tfvars`
This file provides default values for the variables defined in `variables.tf`. It includes values such as the AWS region, AMI IDs, and instance names, and it is automatically loaded by Terraform during execution.

## Getting Started

### Prerequisites
- **Terraform**: Ensure Terraform is installed on your local machine.
- **AWS Account**: You will need an AWS account with the appropriate permissions to create and manage resources.

### Steps to Deploy

1. **Clone the Repository**
   git clone https://github.com/yourusername/nginx-terraform-aws.git
   cd nginx-terraform-aws


2. **Initialize the Terraform Project**
    terraform init
3. **Review the Planned Infrastructure**
    terraform plan
4. **Apply the Terraform Configuration**
    terraform apply
5. **Accessing the bastion**
    http://<bastion-public-ipv4>
6. **Review the Nginx page**
    "yo this is nginx
    glen gold project"
5. **For Clean Up**
    terraform destroy
