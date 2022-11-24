terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.0"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.7.0"
    }
  }

  required_version = "~> 1.3"
}
