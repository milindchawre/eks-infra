env_type = "prod"
prefix   = "milindchawre"

aws_region = {
  primary_region   = "ap-northeast-2"
  secondary_region = "ap-northeast-3"
}

vpc = {
  primary_vpc_id   = "vpc-02d97e84a1f79ef5e"
  secondary_vpc_id = "vpc-0c889a04e87ffb7aa"
}

tags = {
  owner   = "milindchawre"
  project = "wetravel-eks"
}

aurora = {
  engine                = "aurora-postgresql"
  engine_version        = "14.5"
  instance_class        = "db.r5.large"
  db_param_group_family = "aurora-postgresql14"
  db_name               = "todo"
}

eks = {
  primary_cluster   = "milindchawre-eks-seoul-prod"
  secondary_cluster = "milindchawre-eks-osaka-prod"
}

todo_app = {
  region1_url = "todo-app-seoul.prod.wetravel.ml"
  region2_url = "todo-app-osaka.prod.wetravel.ml"
}