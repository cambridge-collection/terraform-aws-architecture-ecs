################################################################################
# Security Groups
################################################################################

resource "aws_security_group" "asg" {
  name        = "${var.name_prefix}-asg"
  description = "Security Group for EC2 Instances in ${var.name_prefix} ASG"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-asg"
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.name_prefix}-alb"
  description = "Application Load Balancer Security Group for ${var.name_prefix} cluster"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-alb"
  }
}

resource "aws_security_group" "vpc_endpoints" {
  count = var.vpc_endpoints_create ? 1 : 0

  name        = "${var.name_prefix}-vpc-endpoints"
  description = "Allows access to VPC Endpoints"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-vpc-endpoints"
  }
}

resource "aws_security_group" "vpc_egress" {
  count = var.vpc_endpoints_create ? 0 : 1

  name        = "${var.name_prefix}-vpc-egress"
  description = "Allows egress from VPC via NAT Gateway"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name = "${var.name_prefix}-vpc-egress"
  }
}

################################################################################
# Security Group Rules
################################################################################

resource "aws_security_group_rule" "vpc_egress_https" {
  count = var.vpc_endpoints_create ? 0 : 1

  type              = "egress"
  protocol          = "tcp"
  description       = "HTTPS outbound access for ${var.name_prefix}"
  security_group_id = aws_security_group.vpc_egress.0.id
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "vpc_egress_http" {
  count = var.vpc_endpoints_create ? 0 : 1

  type              = "egress"
  protocol          = "tcp"
  description       = "HTTP outbound access for ${var.name_prefix}"
  security_group_id = aws_security_group.vpc_egress.0.id
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_ingress_cloudfront" {
  type              = "ingress"
  protocol          = "tcp"
  description       = "HTTPS from CloudFront for ${var.name_prefix}"
  security_group_id = aws_security_group.alb.id
  from_port         = 443
  to_port           = 443
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.cloudfront.id]
}

resource "aws_security_group_rule" "vpc_endpoint_ingress_self" {
  count = var.vpc_endpoints_create ? 1 : 0

  type              = "ingress"
  protocol          = "tcp"
  description       = "VPC Endpoint ingress for ${var.name_prefix}"
  security_group_id = aws_security_group.vpc_endpoints.0.id
  from_port         = 443
  to_port           = 443
  self              = true
}

resource "aws_security_group_rule" "vpc_endpoint_egress_self" {
  count = var.vpc_endpoints_create ? 1 : 0

  type              = "egress"
  protocol          = "tcp"
  description       = "VPC Endpoint egress for ${var.name_prefix}"
  security_group_id = aws_security_group.vpc_endpoints.0.id
  from_port         = 443
  to_port           = 443
  self              = true
}

resource "aws_security_group_rule" "vpc_endpoints_egress_s3" {
  count = var.vpc_endpoints_create ? 1 : 0

  type              = "egress"
  protocol          = "tcp"
  description       = "Egress to S3 for ${var.name_prefix}"
  security_group_id = aws_security_group.vpc_endpoints.0.id
  from_port         = 443
  to_port           = 443
  prefix_list_ids   = [data.aws_ec2_managed_prefix_list.s3.id]
}
