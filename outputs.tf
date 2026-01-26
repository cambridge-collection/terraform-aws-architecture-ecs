output "vpc_id" {
  value       = aws_vpc.this.id
  description = "VPC ID"
}

output "vpc_public_subnet_ids" {
  value       = aws_subnet.public.*.id
  description = "Public Subnet IDs"
}

output "vpc_private_subnet_ids" {
  value       = aws_subnet.private.*.id
  description = "Private Subnet IDs"
}

output "vpc_availability_zones" {
  value       = slice(data.aws_availability_zones.available.names, 0, var.vpc_subnets_count)
  description = "List of availability zones enabled in VPC"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.this.name
  description = "Name of the ECS Cluster"
}

output "ecs_cluster_arn" {
  value       = aws_ecs_cluster.this.arn
  description = "ARN of the ECS Cluster"
}

output "ecs_capacity_provider_name" {
  value       = aws_ecs_capacity_provider.this.name
  description = "Name of the ECS Capacity Provider associated with the Autoscaling Group"
}

output "s3_bucket" {
  value       = var.s3_bucket_create ? aws_s3_bucket.this.0.id : ""
  description = "Name of the S3 Bucket"
}

output "s3_bucket_arn" {
  value       = var.s3_bucket_create ? aws_s3_bucket.this.0.arn : ""
  description = "ARN of the S3 Bucket"
}

output "alb_arn" {
  value       = var.alb_create ? aws_lb.this.0.arn : var.output_undefined
  description = "ARN of the Application Load Balancer"
}

output "alb_https_listener_arn" {
  value       = var.alb_create ? aws_lb_listener.https.0.arn : var.output_undefined
  description = "ARN of the default Application Load Balancer Listener on port 443"
}

output "alb_dns_name" {
  value       = var.alb_create ? aws_lb.this.0.dns_name : var.output_undefined
  description = "DNS Name of the Application Load Balancer"
}

output "asg_name" {
  value       = var.ecs_capacity_provider_managed_instances ? "" : aws_autoscaling_group.this.0.name
  description = "Name of the Auto Scaling Group"
}

output "alb_security_group_id" {
  value       = var.alb_create ? aws_security_group.alb.0.id : var.output_undefined
  description = "ID of the Security Group for the Application Load Balancer"
}

output "asg_security_group_id" {
  value       = aws_security_group.asg.id
  description = "ID of the Security Group for the Auto Scaling Group"
}

output "vpc_endpoint_security_group_id" {
  value       = var.vpc_endpoints_create ? aws_security_group.vpc_endpoints.0.id : ""
  description = "ID of the Security Group for VPC Endpoints"
}

output "vpc_egress_security_group_id" {
  value       = var.vpc_endpoints_create ? "" : aws_security_group.vpc_egress.0.id
  description = "ID of the Security Group for general egress"
}

output "route53_public_hosted_zone" {
  value       = coalescelist(data.aws_route53_zone.existing.*.id, aws_route53_zone.public.*.id, [var.output_undefined])[0]
  description = "Zone ID of the Route 53 Public Hosted Zone"
}

output "cloudwatch_log_group_arn" {
  value       = var.cloudwatch_log_group_exists ? data.aws_cloudwatch_log_group.existing.0.arn : aws_cloudwatch_log_group.this.0.arn
  description = "ARN of the CloudWatch Log Group"
}

output "cloudwatch_log_group_name" {
  value       = var.cloudwatch_log_group_exists ? data.aws_cloudwatch_log_group.existing.0.name : aws_cloudwatch_log_group.this.0.name
  description = "Name of the CloudWatch Log Group"
}

output "waf_acl_arn" {
  value       = aws_wafv2_web_acl.this.arn
  description = "ARN of the WAF Web ACL"
}
