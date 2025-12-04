################################################################################
# VPC
################################################################################

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

################################################################################
# Subnets
################################################################################

resource "aws_subnet" "public" {
  count = var.vpc_subnets_count

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = length(var.vpc_public_subnet_cidr_blocks) > 0 ? var.vpc_public_subnet_cidr_blocks[count.index] : cidrsubnet(var.vpc_cidr_block, 4, count.index)
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = var.vpc_public_subnet_public_ip

  tags = {
    Name = "${var.name_prefix}-subnet-public-${data.aws_availability_zones.available.names[count.index]}"
  }
}

resource "aws_subnet" "private" {
  count = var.vpc_subnets_count

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = length(var.vpc_private_subnet_cidr_blocks) > 0 ? var.vpc_private_subnet_cidr_blocks[count.index] : cidrsubnet(var.vpc_cidr_block, 4, length(data.aws_availability_zones.available.names) + count.index)
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = false # always false

  tags = {
    Name = "${var.name_prefix}-subnet-private-${data.aws_availability_zones.available.names[count.index]}"
  }
}

################################################################################
# Route Tables
################################################################################

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-rtb-main"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-rtb-public"
  }
}

resource "aws_route_table" "private" {
  count = var.vpc_subnets_count

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.vpc_nat_gateway_single ? aws_nat_gateway.nat[0].id : aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name = "${var.name_prefix}-rtb-private-${data.aws_availability_zones.available.names[count.index]}"
  }
}

################################################################################
# Route Table Subnet Associations
################################################################################

resource "aws_route_table_association" "public" {
  count = var.vpc_subnets_count

  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

resource "aws_route_table_association" "private" {
  count = var.vpc_subnets_count

  route_table_id = aws_route_table.private[count.index].id
  subnet_id      = aws_subnet.private[count.index].id
}

################################################################################
# DHCP Options Set
################################################################################

resource "aws_vpc_dhcp_options" "this" {
  domain_name         = "${data.aws_region.current.name}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    Name = "${var.name_prefix}-vpc-dhcp-options"
  }
}

resource "aws_vpc_dhcp_options_association" "this" {
  dhcp_options_id = aws_vpc_dhcp_options.this.id
  vpc_id          = aws_vpc.this.id
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-igw"
  }
}

resource "aws_route" "cudl_vpc_ec2_route_igw" {
  gateway_id             = aws_internet_gateway.this.id
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
}

################################################################################
# VPC Endpoints
################################################################################

resource "aws_vpc_endpoint" "s3" {
  count = var.vpc_endpoints_create ? 1 : 0

  vpc_endpoint_type   = "Gateway"
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids     = aws_route_table.private.*.id
  private_dns_enabled = false

  tags = {
    Name = "${var.name_prefix}-vpc-endpoint-s3"
  }
}

resource "aws_vpc_endpoint" "interface" {
  for_each = var.vpc_endpoints_create ? toset(var.vpc_endpoint_services) : toset([])

  vpc_endpoint_type   = "Interface"
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.value}"
  subnet_ids          = aws_subnet.private.*.id
  security_group_ids  = [aws_security_group.vpc_endpoints.0.id]
  private_dns_enabled = true

  dns_options {
    dns_record_ip_type = var.vpc_endpoint_dns_record_ip_type
  }

  tags = {
    Name = "${var.name_prefix}-vpc-endpoint-${each.value}"
  }
}

################################################################################
# NAT Gateway
################################################################################

locals {
  nat_gateway_count = var.vpc_nat_gateway_single ? 1 : var.vpc_subnets_count
}

resource "aws_nat_gateway" "nat" {
  count = local.nat_gateway_count

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.name_prefix}-nat-${aws_subnet.public[count.index].availability_zone}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.this]
}

resource "aws_eip" "nat" {
  count = local.nat_gateway_count

  domain = "vpc"

  tags = {
    Name = "${var.name_prefix}-nat-elastic-ip-${aws_subnet.public[count.index].availability_zone}"
  }
}

################################################################################
# Default Security Group
################################################################################

# NOTE Adopt the default security group of the VPC to remove all ingress and egress rules
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "default"
  }
}

################################################################################
# VPC Peering
################################################################################

resource "aws_vpc_peering_connection" "this" {
  for_each = toset(var.vpc_peering_vpc_ids)

  peer_vpc_id = aws_vpc.this.id # accepter
  vpc_id      = each.key        # requester
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true # Allow requester VPC to resolve DNS of hosts in accepter VPC to private IP addresses
  }

  requester {
    allow_remote_vpc_dns_resolution = false # Allow accepter VPC to resolve DNS of hosts in requester VPC to private IP addresses
  }
}
