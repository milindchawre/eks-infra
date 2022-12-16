locals {
  primary_dbcluster_name   = "${var.prefix}-db-${var.aws_region.primary_region}-${var.env_type}"
  secondary_dbcluster_name = "${var.prefix}-db-${var.aws_region.secondary_region}-${var.env_type}"
}

provider "aws" {
  region = var.aws_region.primary_region
}

provider "aws" {
  alias  = "secondary_region"
  region = var.aws_region.secondary_region
}

provider "kubernetes" {
  alias                  = "primary_cluster"
  host                   = data.aws_eks_cluster.primary_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.primary_cluster.certificate_authority[0].data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.primary_cluster.id]
  }
}

provider "kubernetes" {
  alias                  = "secondary_cluster"
  host                   = data.aws_eks_cluster.secondary_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.secondary_cluster.certificate_authority[0].data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.secondary_cluster.id]
  }
}