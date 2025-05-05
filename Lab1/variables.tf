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


variable "allowed_ip" {
  description = "Allowed IP for EC2"
  type        = string
}

variable "public_instance_count" {
  description = "Number of public EC2 instances"
  type        = number
}

variable "private_instance_count" {
  description = "Number of private EC2 instances"
  type        = number
}