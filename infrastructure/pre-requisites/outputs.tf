output "acm_certificate_arn_region1" {
  description = "ACM Certificate ARN for region1"
  value       = module.acm.acm_certificate_arn
}

output "acm_certificate_arn_region2" {
  description = "ACM Certificate ARN for region2"
  value       = module.acm_secondary.acm_certificate_arn
}

output "s3_bucket" {
  description = "S3 bucket to store terraform state"
  value       = aws_s3_bucket.terraform-state.id
}

output "dynamodb_table" {
  description = "DynamoDB table to store terraform state lock"
  value       = aws_dynamodb_table.terraform-state.id
}

output "ecr_repo" {
  description = "ECR Repo"
  value       = aws_ecr_repository.image_registry.repository_url
}

output "route53_domain_name" {
  description = "Route53 domain name"
  value       = aws_route53_zone.my_hosted_zone.name
}

output "route53_zone_id" {
  description = "Route53 zone id"
  value       = aws_route53_zone.my_hosted_zone.zone_id
}

output "aws_primary_region" {
  description = "AWS Primary Region"
  value       = var.aws_region.primary_region
}

output "aws_secondary_region" {
  description = "AWS Secondary Region"
  value       = var.aws_region.secondary_region
}