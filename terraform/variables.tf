variable "aws_region" {
  description = "The AWS region to deploy resources."
  default     = "eu-central-1"
}

variable "bastion_ami" {
  description = "The AMI to use for the bastion instance."
  default     = "ami-071878317c449ae48"
}

variable "custom_ami" {
  description = "The AMI to use for the custom instance."
  default     = "ami-071878317c449ae48"
}

variable "bastion_instance_name" {
  description = "Name for the bastion instance."
  default     = "bastion"
}

variable "nginx_instance_name" {
  description = "Name for the nginx instance."
  default     = "nginx"
}

variable "vpc_name" {
  description = "The name of the VPC."
  default     = "my-vpc"
}

variable "availability_zones" {
  description = "The availability zones for the VPC."
  default     = ["eu-central-1a"]
}

variable "private_subnets" {
  description = "The private subnets for the VPC."
  default     = ["10.0.1.0/24"]
}

variable "public_subnets" {
  description = "The public subnets for the VPC."
  default     = ["10.0.101.0/24"]
}

variable "cidr_block" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "s3-bucket-name" {
  description = "The name of the S3 bucket."
  default     = "my-terraform-state-bucket-nginx"
}
