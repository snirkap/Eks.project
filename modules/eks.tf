module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
  vpc_id                   = "vpc-043038dbef4c9a40e"
  subnet_ids               = ["subnet-0c0224566e63bf9b5", "subnet-0a48981f36fa2dee4", "subnet-0c0de02b38cc8144d"]
  control_plane_subnet_ids = ["subnet-0c0224566e63bf9b5", "subnet-0a48981f36fa2dee4", "subnet-0c0de02b38cc8144d"]

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t2.micro"]
  }
  eks_managed_node_groups = {
    example = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_types = ["t2.micro"]
      capacity_type  = "SPOT"
    }
  }
  enable_cluster_creator_admin_permissions = true
}