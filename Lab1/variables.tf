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
