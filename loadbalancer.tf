resource "aws_lb" "this" {
  name               = trimsuffix(substr("${var.name_prefix}-alb", 0, 32), "-")
  internal           = var.alb_internal
  load_balancer_type = "application"
  subnets            = var.alb_internal ? [aws_subnet.private_a.id, aws_subnet.private_b.id] : [aws_subnet.public_a.id, aws_subnet.public_b.id]
  security_groups = [
    aws_security_group.alb.id
  ]
  ip_address_type                  = "ipv4"
  idle_timeout                     = var.alb_idle_timeout
  enable_deletion_protection       = var.alb_enable_deletion_protection
  enable_http2                     = true
  enable_cross_zone_load_balancing = true # NOTE this is always true for an ALB

  dynamic "access_logs" {
    for_each = var.alb_access_logs_enabled ? [1] : []
    content {
      enabled = var.alb_access_logs_enabled
      bucket  = var.alb_access_logs_bucket
      prefix  = var.alb_access_logs_prefix
    }
  }
}
