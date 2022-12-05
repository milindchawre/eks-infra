# s3 bucket
resource "aws_s3_bucket" "terraform-state" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_acl" "terraform-state" {
  bucket = aws_s3_bucket.terraform-state.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.terraform-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.terraform-state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# dynamoDB table
resource "aws_dynamodb_table" "terraform-state" {
  name           = var.dynamodb_table
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# AWS ECR repo
resource "aws_ecr_repository" "image_registry" {
  name                 = var.ecr_repo
  image_tag_mutability = "MUTABLE"
}

# configure OIDC between GitHub Actions and AWS
module "oidc-with-github-actions" {
  source  = "thetestlabs/oidc-with-github-actions/aws"
  version = "0.1.5"

  github_org           = var.oidc.github_org_name
  github_repositories  = var.oidc.github_repos
  iam_role_name        = var.oidc.iam_role_name
  iam_role_description = "Enable GitHub OIDC access"
  max_session_duration = var.oidc.max_session_duration
  iam_role_policy      = var.oidc.iam_role_policy
  iam_role_path        = "/"
}

# Route53 domain
resource "aws_route53_zone" "my_hosted_zone" {
  name    = var.domain_name
  comment = var.domain_name

  tags = {
    Name = var.domain_name
  }
}

#ACM certificate
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "4.2.0"

  domain_name = var.domain_name
  zone_id     = aws_route53_zone.my_hosted_zone.zone_id

  subject_alternative_names = [
    "*.${var.domain_name}",
    "*.prod.${var.domain_name}",
    "*.dev.${var.domain_name}",
    "*.test.${var.domain_name}",
    "*.staging.${var.domain_name}",
  ]

  wait_for_validation = true

  tags = {
    Name = var.domain_name
  }
}