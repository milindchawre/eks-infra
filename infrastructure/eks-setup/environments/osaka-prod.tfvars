env_type = "prod"
prefix   = "milindchawre"

tags = {
  owner   = "milindchawre"
  project = "wetravel-eks"
}

region = "osaka"

cluster_version = "1.24"

node_pool_app = {
  name      = "app-eks-nodepool"
  vm_type   = ["t3.medium"]
  min_nodes = 1
  max_nodes = 3
}

aws_alb_controller = {
  namespace       = "ingress"
  chart_version   = "1.4.6"
  timeout_seconds = 3600
  config_file     = "./config/aws_alb_controller.yml"
  config_content  = ""
  replica_count   = 2
}

external_dns = {
  namespace       = "ingress"
  chart_version   = "1.11.0"
  timeout_seconds = 3600
  domain          = "wetravel.ml"
  policy          = "upsert-only"
  aws_zone_type   = "public"
  aws_region      = "ap-northeast-3"
}

# this iam role is created in pre-requisites module
oidc_iam_role = "arn:aws:iam::995105043624:role/milindchawre_oidc_role"

vpc = {
  cidr             = "192.168.0.0/16"
  private_subnets  = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
  public_subnets   = ["192.168.4.0/24", "192.168.5.0/24", "192.168.6.0/24"]
  database_subnets = ["192.168.7.0/24", "192.168.8.0/24", "192.168.9.0/24"]
}