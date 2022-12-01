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

external_dns = {
  namespace       = "ingress"
  chart_version   = "1.11.0"
  timeout_seconds = 3600
  domain          = "wetravel.ml"
  policy          = "sync"
  aws_zone_type   = "public"
  aws_region      = "ap-northeast-2"
}

# this iam role is created in pre-requisites module
oidc_iam_role = "arn:aws:iam::995105043624:role/milindchawre_oidc_role"

rds = {
  db_identifier            = "todo-app-db"
  db_engine                = "postgres"
  db_version               = "14.3"
  db_instance_class        = "db.t4g.micro"
  db_storage               = 10
  db_name                  = "todo"
  db_user                  = "postgres"
  db_port                  = 5432
  db_backup_retention_days = 1
  db_family                = "postgres14"
  db_major_version         = "14"
  db_deletion_protection   = false
}