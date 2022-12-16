output "vpc_connection_peering_id" {
  description = "VPC Connection Peering ID"
  value       = aws_vpc_peering_connection.peer.id
}

output "route53_heathcheck_id_region1" {
  description = "Route53 healthcheck id for app in region1"
  value       = aws_route53_health_check.region1_app.id
}

output "route53_heathcheck_id_region2" {
  description = "Route53 healthcheck id for app in region2"
  value       = aws_route53_health_check.region2_app.id
}