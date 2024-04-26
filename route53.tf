resource "aws_route53_zone" "public" {
  name              = var.route53_zone_domain_name
  delegation_set_id = var.route53_delegation_set_id
  force_destroy     = var.route53_zone_force_destroy
}
