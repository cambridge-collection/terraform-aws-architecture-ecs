resource "aws_route53_zone" "public" {
  count = var.route53_zone_id_existing != null ? 0 : 1

  name              = var.route53_zone_domain_name
  delegation_set_id = var.route53_delegation_set_id
  force_destroy     = var.route53_zone_force_destroy
}
