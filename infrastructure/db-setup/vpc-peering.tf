data "aws_caller_identity" "secondary_region" {
  provider = aws.secondary_region
}

# Requester's side of the connection
resource "aws_vpc_peering_connection" "peer" {
  peer_owner_id = data.aws_caller_identity.secondary_region.account_id
  peer_vpc_id   = var.vpc.secondary_vpc_id
  vpc_id        = var.vpc.primary_vpc_id
  peer_region   = var.aws_region.secondary_region

  tags = merge(var.tags, { Side = "Requester" })
}

# Accepter's side of the connection
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.secondary_region
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = merge(var.tags, { Side = "Accepter" })
}

resource "aws_vpc_peering_connection_options" "requester" {

  # As options can't be set until the connection has been accepted
  # create an explicit dependency on the accepter.
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "accepter" {
  provider = aws.secondary_region

  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.peer.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

# Update AWS Route Tables after VPC Peering
data "aws_vpc" "primary" {
  id = var.vpc.primary_vpc_id
}

data "aws_vpc" "secondary" {
  provider = aws.secondary_region
  id       = var.vpc.secondary_vpc_id
}

data "aws_route_tables" "primary" {
  vpc_id = var.vpc.primary_vpc_id
}

data "aws_route_tables" "secondary" {
  provider = aws.secondary_region
  vpc_id   = var.vpc.secondary_vpc_id
}

resource "aws_route" "primary" {
  count                     = length(data.aws_route_tables.primary.ids)
  route_table_id            = data.aws_route_tables.primary.ids[count.index]
  destination_cidr_block    = data.aws_vpc.secondary.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "secondary" {
  provider                  = aws.secondary_region
  count                     = length(data.aws_route_tables.secondary.ids)
  route_table_id            = data.aws_route_tables.secondary.ids[count.index]
  destination_cidr_block    = data.aws_vpc.primary.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}