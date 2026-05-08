data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ec2_managed_prefix_list" "cloudfront" {
  count = var.cloudfront_create_vpc_origin ? 0 : 1
  name  = "com.amazonaws.global.cloudfront.origin-facing"
}

data "aws_ec2_managed_prefix_list" "s3" {
  name = "com.amazonaws.${data.aws_region.current.name}.s3"
}

data "aws_ami" "ecs_ami" {
  owners      = ["591542846629"] # AWS Managed
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name_prefix]
  }

  filter {
    name   = "architecture"
    values = [var.ami_architecture]
  }
}

data "aws_cloudwatch_log_group" "existing" {
  count = var.cloudwatch_log_group_exists ? 1 : 0

  name = var.cloudwatch_log_group
}

data "aws_kms_alias" "ebs" {
  name = "alias/aws/ebs"
}

data "aws_route53_zone" "existing" {
  count = var.route53_zone_id_existing != null ? 1 : 0

  zone_id = var.route53_zone_id_existing
}

data "aws_security_group" "cloudfront_vpc_origin" {
  count  = var.cloudfront_create_vpc_origin ? 1 : 0
  name   = "CloudFront-VPCOrigins-Service-SG"
  vpc_id = aws_vpc.this.id

  depends_on = [aws_cloudfront_vpc_origin.this]
}
