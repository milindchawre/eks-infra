provider "aws" {
  region = var.aws_region.primary_region
}

provider "aws" {
  alias  = "secondary_region"
  region = var.aws_region.secondary_region
}