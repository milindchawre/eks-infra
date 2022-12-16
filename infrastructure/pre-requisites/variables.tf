variable "bucket_name" {
  description = "Name of s3 bucket that stores terraform state"
  type        = string
  default     = ""
}

variable "dynamodb_table" {
  description = "dynamodb table that holds terraform state"
  type        = string
  default     = ""
}

variable "ecr_repo" {
  description = "Name of ECR repo"
  type        = string
  default     = ""
}

variable "oidc" {
  description = "Configure OIDC between GitHub Actions and AWS"
  type = object({
    github_org_name      = string
    github_repos         = list(string)
    iam_role_name        = string
    max_session_duration = number
    iam_role_policy      = string
  })
}

variable "domain_name" {
  description = "Route53 domain name"
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS Regions"
  type = object({
    primary_region   = string
    secondary_region = string
  })
}