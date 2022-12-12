output "vpc_connection_peering_id" {
  description = "VPC Connection Peering ID"
  value       = aws_vpc_peering_connection.peer.id
}