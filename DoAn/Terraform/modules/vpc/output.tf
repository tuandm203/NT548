output "vpc_id" {
  description = "ID VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "List ID public subnets"
  value       = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  description = "List ID private subnets"
  value       = aws_subnet.private_subnet[*].id
}

output "internet_gateway_id" {
  description = "ID Internet Gateway"
  value       = aws_internet_gateway.ig.id
}

output "default_security_group_id" {
  description = "ID Default Security Group"
  value       = aws_default_security_group.default.id
}