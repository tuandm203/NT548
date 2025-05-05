output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.vpc_id
}

output "internet_gateway_id" {
  value = module.vpc.private_subnet_ids
}

output "default_security_group_id" {
  value = module.vpc.internet_gateway_id
}

# output "ec2_instance_id" {
#   value = module.ec2.ec2_instance_id
# }

# output "ec2_public_ip" {
#   value = module.ec2.ec2_public_ip
# }
