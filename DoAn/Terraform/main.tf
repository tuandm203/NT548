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

module "security_groups" {
  source           = "./modules/security_groups"
  vpc_id  = module.vpc.vpc_id
  my_ip = var.allowed_ip 
}

module "ec2" {
  source                 = "./modules/ec2"
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  public_subnet_ids      = module.vpc.public_subnet_ids
  private_subnet_ids     = module.vpc.private_subnet_ids
  public_sg_id           = module.security_groups.public_security_group_id
  private_sg_id          = module.security_groups.private_security_group_id
  key_name               = aws_key_pair.ec2_keypair.key_name
  public_instance_count  = var.public_instance_count
  private_instance_count = var.private_instance_count
}


resource "local_file" "private_ec2_key" {
    filename                = "private_ec2_key.pem"
    file_permission         = "600"
    directory_permission    = "700"
    content                 = tls_private_key.ssh.private_key_pem
}

resource "aws_key_pair" "ec2_keypair" {
  key_name   = "ec2_keypair"
  public_key = tls_private_key.ssh.public_key_openssh
}
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# --- IAM Role cho EKS (nếu bạn không dùng sẵn IAM role khác) ---
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.vpc_name}-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume.json
}

data "aws_iam_policy_document" "eks_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSVPCResourceController" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

# IAM Role cho Node Group
resource "aws_iam_role" "eks_node_role" {
  name = "${var.vpc_name}-eks-node-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume.json
}

data "aws_iam_policy_document" "eks_node_assume" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# ======================
# Bổ sung module EKS
module "eks" {
  source               = "./modules/eks"

  cluster_name         = "${var.vpc_name}-eks"
  ssh_key_name         = aws_key_pair.ec2_keypair.key_name
  kubernetes_version   = "1.28"
  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  private_subnet_ids   = module.vpc.private_subnet_ids

  cluster_role_arn     = aws_iam_role.eks_cluster_role.arn
  node_role_arn        = aws_iam_role.eks_node_role.arn

  node_instance_types  = ["t2.medium"]
  node_desired_size    = 2
  node_min_size        = 2
  node_max_size        = 2
}

# Cho phép EC2 public SG kết nối API-server của EKS
resource "aws_security_group_rule" "allow_ec2_to_eks" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = module.security_groups.public_security_group_id
  source_security_group_id = module.eks.cluster_security_group_id
}

resource "aws_security_group_rule" "allow_eks_to_ec2" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = module.eks.cluster_security_group_id
  source_security_group_id = module.security_groups.public_security_group_id
}
