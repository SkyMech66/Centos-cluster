variable "vpc_name" {
  type        = string
  description = "VPC name"
  default     = "centos-vpc"
}

variable "image" {
  type        = string
  description = "image for container"
  default     = "centos:latest"
}

variable "region" {
  type        = string
  description = "The AWS region"
  default     = "us-east-1"
}

variable "aws_access_key" {
  sensitive = true
}

variable "aws_secret_access_key" {
  sensitive = true
}

variable "cidr_block" {
  type        = string
  description = "The VPC CIDR range"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnet CIDR block ranges"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet CIDR block ranges"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "List of Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
}
