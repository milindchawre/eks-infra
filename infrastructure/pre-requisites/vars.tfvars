bucket_name    = "milindchawre-tf-states"
dynamodb_table = "milindchawre-terraform-state"
ecr_repo       = "image-store"

aws_region = {
  primary_region   = "ap-northeast-2"
  secondary_region = "ap-northeast-3"
}

oidc = {
  github_org_name      = "milindchawre"
  github_repos         = ["eks-infra", "todo"]
  iam_role_name        = "milindchawre_oidc_role"
  max_session_duration = 7200
  iam_role_policy      = "AdministratorAccess"
}

domain_name = "wetravel.ml"