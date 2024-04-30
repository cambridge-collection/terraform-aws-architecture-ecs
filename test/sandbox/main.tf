module "base_architecture" {
  source = "../.."

  name_prefix                    = join("-", compact([local.environment, var.cluster_name_suffix]))
  route53_zone_domain_name       = var.registered_domain_name
  route53_delegation_set_id      = var.route53_delegation_set_id
  route53_zone_force_destroy     = var.route53_zone_force_destroy
  alb_enable_deletion_protection = var.alb_enable_deletion_protection
  vpc_public_subnet_public_ip    = var.vpc_public_subnet_public_ip
  cloudwatch_log_group           = var.cloudwatch_log_group # TODO create log group
  tags                           = local.default_tags
}
