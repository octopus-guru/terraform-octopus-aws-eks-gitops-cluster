variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}
variable "project_name" {
  description = "AWS region"
  type        = string
  default     = "education"
}

# EKS Settings
variable "eks_version" {
  description = "AWS EKS version"
  type        = string
  default     = "1.28"
}

# variable "managed_node_groups" {
#   type = map(string)

#   default = {
#     name           = "node-group-1"
#     instance_types = ["t3.small"]
#     min_size       = 1
#     max_size       = 3
#     desired_size   = 2
#   }
# }


variable "eks_addon" {
  description = "Desire witch EKS addons you will have enabled."
  type = object({
    ebs_csi = object({
      version = string
      enabled = bool
    })
    efs_csi = object({
      version = string
      enabled = bool
    })
    coredns = object({
      version = string
      enabled = bool
    })
    kube_proxy = object({
      version = string
      enabled = bool
    })
    vpc_cni = object({
      version = string
      enabled = bool
    })
  })

  default = {
    ebs_csi = {
      enabled = true
      version = "v1.26.1-eksbuild.1"
    }
    efs_csi = {
      enabled = true
      version = "v1.7.3-eksbuild.1"
    }
    coredns = {
      enabled = true
      version = "v1.10.1-eksbuild.6"
    }
    kube_proxy = {
      enabled = true
      version = "v1.28.4-eksbuild.4"
    }
    vpc_cni = {
      enabled = true
      version = "v1.16.0-eksbuild.1"
    }
  }
}

# VPC Settings
variable "vpc_create" {
  description = "Allow VPC to been created or use already exists VPC."
  type        = bool
  default     = true
}
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "education-vpc"
}
variable "vpc_cidr" {
  description = "VPC CIDR range"
  type        = string
  default     = "10.0.0.0/16"
}
variable "vpc_max_azs" {
  description = "VPC Maximum AZ"
  type        = number
  default     = 1
}
variable "vpc_private_subnets" {
  description = "Private subnet range, count of entry shoud be equest with vpc_asz size"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
variable "vpc_public_subnets" {
  description = "Public subnet range, count of entry shoud be equest with vpc_asz size"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}
