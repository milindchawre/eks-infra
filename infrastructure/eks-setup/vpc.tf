module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = "${local.cluster_name}-vpc"

  #cidr = "10.0.0.0/16"
  cidr = var.vpc.cidr

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  #private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  #public_subnets   = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  #database_subnets = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
  private_subnets  = var.vpc.private_subnets
  public_subnets   = var.vpc.public_subnets
  database_subnets = var.vpc.database_subnets

  enable_nat_gateway = true
  single_nat_gateway = true
  enable_vpn_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  database_subnet_tags = {
    "subnet_type" = "database"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}