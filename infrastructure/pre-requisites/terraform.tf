provider "aws" {
  region = var.aws_region.primary_region
}

provider "aws" {
  alias  = "secondary_region"
  region = var.aws_region.secondary_region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }
  }

  required_version = "~> 1.3"
}