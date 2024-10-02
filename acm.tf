locals {
  route53_zone_domain_name = var.route53_zone_id_existing != null ? data.aws_route53_zone.existing.0.name : aws_route53_zone.public.0.name
  default_domain_name      = lower(trim(substr(join(".", ["default", var.name_prefix, local.route53_zone_domain_name]), -64, -1), ".-"))
}

# NOTE see section "Note about Load Balancer Listener" in README.md
resource "aws_acm_certificate" "default" {
  count = var.acm_create_certificate ? 1 : 0

  domain_name = local.default_domain_name
  subject_alternative_names = [
    local.default_domain_name
  ]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "default" {
  count = var.acm_create_certificate ? 1 : 0

  certificate_arn         = aws_acm_certificate.default.0.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation_cname : record.fqdn]

  timeouts {
    create = "10m"
  }
}
