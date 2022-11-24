env_type = "prod"
prefix   = "milindchawre"

tags = {
  owner   = "milindchawre"
  project = "wetravel-eks"
}

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

oidc_iam_role = "arn:aws:iam::995105043624:role/milindchawre_oidc_role"