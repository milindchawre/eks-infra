bucket_name    = "milindchawre-tf-states"
dynamodb_table = "milindchawre-terraform-state"
ecr_repo = "image-store"

oidc = {
    github_org_name = "milindchawre"
    github_repos = ["eks-infra", "todo"]
    iam_role_name = "milindchawre_oidc_role"
    max_session_duration = 7200
    iam_role_policy = "AdministratorAccess"
}