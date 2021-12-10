data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "17.24.0"
  cluster_name                    = var.cluster_name
  cluster_version                 = var.cluster_version
  vpc_id                          = module.vpc.vpc_id
  subnets                         = [for sb in module.vpc.private_subnets : sb]
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cluster_create_timeout          = "1h"
  enable_irsa                     = true
  

  worker_additional_security_group_ids = [aws_security_group.worker_group_mgmt.id]
  node_groups_defaults = {
    disk_size = 50
  }

  node_groups = {
    node_group = {
      desired_capacity = 1
      max_capacity     = 1
      min_capacity     = 1

      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"
      k8s_labels = {
        Environment = "karpenter"
      }
      update_config = {
        max_unavailable_percentage = 50
      }
    }
  }

  tags = {
    Name = "karpenter-cluster"
  }
}