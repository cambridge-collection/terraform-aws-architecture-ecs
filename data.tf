data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_ec2_managed_prefix_list" "cloudfront" {
  name = "com.amazonaws.global.cloudfront.origin-facing"
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

data "aws_cloudwatch_log_group" "this" {
  name = var.cloudwatch_log_group
}

data "aws_kms_alias" "ebs" {
  name = "alias/aws/ebs"
}

data "aws_route53_zone" "existing" {
  count = var.route53_zone_id_existing != null ? 1 : 0

  zone_id = var.route53_zone_id_existing
}
