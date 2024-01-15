locals {
  cluster_name = "${var.project_name}-${terraform.workspace}-eks"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name    = local.cluster_name
  cluster_version = var.eks_version

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }
}


# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "4.7.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "ebs-csi" {
  count = var.eks_addon.ebs_csi.enabled ? 1 : 0

  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = var.eks_addon.ebs_csi.version
  service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
}

resource "aws_eks_addon" "coredns" {
  count = var.eks_addon.coredns.enabled ? 1 : 0


  cluster_name  = module.eks.cluster_name
  addon_name    = "coredns"
  addon_version = var.eks_addon.coredns.version
  tags = {
    "eks_addon" = "CoreDNS"
    "terraform" = "true"
  }
}

resource "aws_eks_addon" "kube-proxy" {
  count = var.eks_addon.kube_proxy.enabled ? 1 : 0

  cluster_name  = module.eks.cluster_name
  addon_name    = "kube-proxy"
  addon_version = var.eks_addon.kube_proxy.version
  tags = {
    "eks_addon" = "KubeProxy"
    "terraform" = "true"
  }
}

resource "aws_eks_addon" "vpc-cni" {
  count = var.eks_addon.vpc_cni.enabled ? 1 : 0

  cluster_name  = module.eks.cluster_name
  addon_name    = "vpc-cni"
  addon_version = var.eks_addon.vpc_cni.version
  tags = {
    "eks_addon" = "Amazon VPC CNI"
    "terraform" = "true"
  }
}

resource "aws_eks_addon" "aws-efs-csi-driver" {
  count = var.eks_addon.efs_csi.enabled ? 1 : 0

  cluster_name  = module.eks.cluster_name
  addon_name    = "aws-efs-csi-driver"
  addon_version = var.eks_addon.efs_csi.version
  tags = {
    "eks_addon" = "Amazon EFS CSI Driver"
    "terraform" = "true"
  }
}
