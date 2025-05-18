# Module: EKS Cluster and Node Group

# Cluster security group
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-sg"
  description = "EKS Cluster communication"
  vpc_id      = var.vpc_id
}

# EKS Cluster
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.kubernetes_version
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids         = concat(var.public_subnet_ids, var.private_subnet_ids)
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
    endpoint_public_access  = true
    endpoint_private_access = false
  }

  tags = {
    Name = var.cluster_name
  }
}

# Node Group
resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-nodes"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  instance_types = var.node_instance_types

  remote_access {
    ec2_ssh_key               = var.ssh_key_name
    source_security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

  tags = {
    Name = "${var.cluster_name}-nodegroup"
  }
}

# aws-auth ConfigMap: map Node Role so nodes can join
provider "kubernetes" {
  host                   = aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.this.name]
  }
}

data "template_file" "aws_auth" {
  template = file("${path.module}/aws-auth.tpl.yaml")
  vars = {
    node_role_arn = var.node_role_arn
  }
}

resource "kubernetes_config_map" "aws_auth" {
  depends_on = [aws_eks_cluster.this, aws_eks_node_group.nodes]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = data.template_file.aws_auth.rendered
  }
  provider = kubernetes
}
