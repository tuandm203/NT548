variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc_name" {
  description = "Tag name VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair name for EC2 instance"
  type        = string
}

variable "allowed_ip_range" {
  description = "Allowed IP range for EC2"
  type        = list(string)
}

variable "public_ip_range" {
  description = "Public IP range for Security Group"
  type        = list(string)
}

variable "private_ip_range" {
  description = "Private IP range for Security Group"
  type        = list(string)
}