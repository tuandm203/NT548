terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region                   = "ap-southeast-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "nhom13"
}

module "vpc" {
  source            = "./modules/vpc"
  vpc_name          = var.vpc_name
  vpc_cidr_block    = var.vpc_cidr_block
  public_subnet     = var.public_subnet_cidrs
  private_subnet    = var.private_subnet_cidrs
  availability_zone = var.availability_zones
}

module "nat_gateway" {
  source            = "./modules/nat_gateway"
  public_subnet_ids = module.vpc.public_subnet_ids
}

module "route_table" {
  source              = "./modules/route_table"
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  private_subnet_ids  = module.vpc.private_subnet_ids
  internet_gateway_id = module.vpc.internet_gateway_id
  nat_gateway_id      = module.nat_gateway.nat_gateway_id
}

module "ec2" {
  source           = "./modules/ec2"
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  key_name         = var.key_name
  allowed_ip_range = var.allowed_ip_range
}




module "security_groups" {
  source           = "./modules/security_groups"
  public_ip_range  = var.public_ip_range
  private_ip_range = var.private_ip_range
}