# Variables in vars.tfvars

| Name | Description |
| :--- | :---------- |
| bucket_name | S3 bucket name where terraform state of EKS cluster will be stored |
| dynamodb_table | DynamoDB table that will store terraform state lock |
| ecr_repo | ECR repository to store docker images of applications |
| oidc | Settings for Github OIDC client to access AWS resources |
| github_org_name | Github org name |
| github_repos | Github repositories |
| iam_role_name | IAM role name which will be assumed by Github OIDC client |
| max_session_duration | Session duration in seconds for OIDC client |
| iam_role_policy | IAM policy which will be assumed by Github OIDC client |
| domain_name | Route53 domain name |
