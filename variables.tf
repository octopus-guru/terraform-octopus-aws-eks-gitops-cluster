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


variable "eks_addon" {
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
variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = ""
}
variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}
variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "education-vpc"
}
