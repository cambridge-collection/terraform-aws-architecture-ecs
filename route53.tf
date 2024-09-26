locals {
  route53_public_hosted_zone_id   = coalescelist(data.aws_route53_zone.existing.*.id, aws_route53_zone.public.*.id)[0]
  route53_public_hosted_zone_name = coalescelist(data.aws_route53_zone.existing.*.name, aws_route53_zone.public.*.name)[0]
}

resource "aws_route53_delegation_set" "this" {
  count = var.route53_zone_id_existing != null ? 0 : 1

  reference_name = var.route53_delegation_set_reference_name
}

resource "aws_route53_zone" "public" {
  count = var.route53_zone_id_existing != null ? 0 : 1

  name              = var.route53_zone_domain_name
  delegation_set_id = coalesce(var.route53_delegation_set_id, aws_route53_delegation_set.this[0].id)
  force_destroy     = var.route53_zone_force_destroy
}

resource "aws_route53_record" "acm_validation_cname" {
  for_each = {
    for dvo in aws_acm_certificate.default.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = local.route53_public_hosted_zone_id
}
