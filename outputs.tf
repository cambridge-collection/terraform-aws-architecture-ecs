output "vpc_id" {
  value       = aws_vpc.this.id
  description = "VPC ID"
}

output "vpc_public_subnet_ids" {
  value       = [aws_subnet.public_a.id, aws_subnet.public_b.id]
  description = "Public Subnet IDs"
}

output "vpc_private_subnet_ids" {
  value       = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  description = "Private Subnet IDs"
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
  value       = aws_s3_bucket.this.id
  description = "Name of the S3 Bucket"
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "ARN of the S3 Bucket"
}

output "alb_arn" {
  value       = aws_lb.this.arn
  description = "ARN of the Application Load Balancer"
}

output "alb_https_listener_arn" {
  value       = aws_lb_listener.https.arn
  description = "ARN of the default Application Load Balancer Listener on port 443"
}

output "alb_dns_name" {
  value       = aws_lb.this.dns_name
  description = "DNS Name of the Application Load Balancer"
}

output "asg_name" {
  value       = aws_autoscaling_group.this.name
  description = "Name of the Auto Scaling Group"
}

output "alb_security_group_id" {
  value       = aws_security_group.alb.id
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
  value       = coalescelist(data.aws_route53_zone.existing.*.id, aws_route53_zone.public.*.id)[0]
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
