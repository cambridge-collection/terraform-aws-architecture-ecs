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

resource "aws_subnet" "public_a" {
  availability_zone       = "${data.aws_region.current.name}a"
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 4, 0)
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = var.vpc_public_subnet_public_ip

  tags = {
    Name = "${var.name_prefix}-subnet-public-a"
  }
}

resource "aws_subnet" "public_b" {
  availability_zone       = "${data.aws_region.current.name}b"
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 4, 1)
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = var.vpc_public_subnet_public_ip

  tags = {
    Name = "${var.name_prefix}-subnet-public-b"
  }
}

resource "aws_subnet" "private_a" {
  availability_zone       = "${data.aws_region.current.name}a"
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 4, 2)
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = false # always false

  tags = {
    Name = "${var.name_prefix}-subnet-private-a"
  }
}

resource "aws_subnet" "private_b" {
  availability_zone       = "${data.aws_region.current.name}b"
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 4, 3)
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = false # always false

  tags = {
    Name = "${var.name_prefix}-subnet-private-b"
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

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }

  tags = {
    Name = "${var.name_prefix}-rtb-private-${data.aws_region.current.name}a"
  }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.this.id

  # NOTE missing route

  tags = {
    Name = "${var.name_prefix}-rtb-private_${data.aws_region.current.name}b"
  }
}

################################################################################
# Route Table Subnet Associations
################################################################################

resource "aws_route_table_association" "public_a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_a.id
}

resource "aws_route_table_association" "public_b" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_b.id
}

resource "aws_route_table_association" "private_a" {
  route_table_id = aws_route_table.private_a.id
  subnet_id      = aws_subnet.private_a.id
}

resource "aws_route_table_association" "private_b" {
  route_table_id = aws_route_table.private_b.id
  subnet_id      = aws_subnet.private_b.id
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
  vpc_endpoint_type = "Gateway"
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids = [
    aws_route_table.private_a.id,
    aws_route_table.private_b.id
  ]
  private_dns_enabled = false

  tags = {
    Name = "${var.name_prefix}-vpc-endpoint-s3"
  }
}

# This is needed for connectivity to aws services in private subnets
resource "aws_vpc_endpoint" "interface" {
  for_each          = toset(var.vpc_endpoint_services)
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.${each.value}"
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
  security_group_ids  = [aws_security_group.vpc_endpoints.id]
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

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "${var.name_prefix}-nat-a"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.this]
}

resource "aws_eip" "nat_a" {
  domain = "vpc"

  tags = {
    Name = "${var.name_prefix}-nat-1a-elastic-ip"
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
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = false
  }
}