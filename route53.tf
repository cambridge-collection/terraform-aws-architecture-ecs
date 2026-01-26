resource "aws_route53_zone" "public" {
  count = var.route53_zone_create && var.route53_zone_id_existing == null ? 1 : 0

  name              = var.route53_zone_domain_name
  delegation_set_id = var.route53_delegation_set_id
  force_destroy     = var.route53_zone_force_destroy
}

resource "aws_route53_record" "acm_validation_cname" {
  for_each = var.acm_create_certificate ? {
    for dvo in aws_acm_certificate.default.0.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = var.route53_zone_id_existing != null ? data.aws_route53_zone.existing.0.zone_id : aws_route53_zone.public.0.zone_id
}
