output "vpc_id" {
  value       = aws_vpc.this.id
  description = "VPC ID"
}

output "ecs_cluster_arn" {
  value       = aws_ecs_cluster.this.arn
  description = "ARN of the ECS Cluster"
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

output "route53_public_hosted_zone" {
  value       = aws_route53_zone.public.id
  description = "Zone ID of the Route 53 Public Hosted Zone"
}

output "cloudwatch_log_group_arn" {
  value       = data.aws_cloudwatch_log_group.this.arn
  description = "ARN of the CloudWatch Log Group"
}

output "cloudwatch_log_group_name" {
  value       = data.aws_cloudwatch_log_group.this.name
  description = "Name of the CloudWatch Log Group"
}

output "waf_acl_arn" {
  value       = aws_wafv2_web_acl.this.arn
  description = "ARN of the WAF Web ACL"
}
