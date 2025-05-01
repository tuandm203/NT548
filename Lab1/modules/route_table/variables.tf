variable "vpc_id" {
  description = "ID VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "ID public subnets"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "ID private subnets"
  type        = list(string)
}

variable "internet_gateway_id" {
  description = "ID Internet Gateway"
  type        = string
}

variable "nat_gateway_id" {
  description = "ID NAT Gateways"
  type        = string
}