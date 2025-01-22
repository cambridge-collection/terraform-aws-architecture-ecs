variable "tags" {
  type        = map(string)
  description = "Map of tags for adding to resources"
  default     = {}
}

variable "name_prefix" {
  type        = string
  description = "Name prefix of the ECS Cluster and associated resources"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_public_subnet_public_ip" {
  type        = bool
  description = "Whether to automatically assign public IP addresses in the public subnets"
  default     = false
}

variable "vpc_endpoints_create" {
  type        = bool
  description = "Whether to use VPC Endpoints to access AWS services inside the VPC. Note this can have a cost impact"
  default     = false
}

variable "vpc_endpoint_dns_record_ip_type" {
  type        = string
  description = "The DNS records created for the endpoint"
  default     = "ipv4"
}

variable "vpc_endpoint_services" {
  type        = list(string)
  description = "List of services to create VPC Endpoints for"
  default     = ["ssmmessages", "ssm", "ec2messages", "ecr.api", "ecr.dkr", "ecs", "ecs-agent", "ecs-telemetry", "logs"]
}

variable "vpc_peering_vpc_ids" {
  type        = list(string)
  description = "List of VPC IDS for peering with the VPC"
  default     = []
}

variable "route53_zone_domain_name" {
  type        = string
  description = "Name of the Domain Name used by the Route 53 Zone. Trailing dots are ignored"
  default     = null
}

variable "route53_delegation_set_id" {
  type        = string
  description = "The ID of the reusable delegation set whose NS records should be assigned to the hosted zone"
  default     = null
}

variable "route53_zone_force_destroy" {
  type        = bool
  description = "Whether to destroy the Route 53 Zone although records may still exist"
  default     = false
}

variable "route53_zone_id_existing" {
  type        = string
  description = "ID of an existing Route 53 Hosted zone as an alternative to creating a hosted zone"
  default     = null
}

variable "s3_bucket_versioning_enabled" {
  type        = bool
  description = "Whether to enable S3 bucket versioning"
  default     = true
}

variable "s3_bucket_force_destroy" {
  type        = bool
  description = "Whether to allow a non-empty bucket to be destroyed"
  default     = false
}

variable "ami_name_prefix" {
  type        = string
  description = "Prefix used to find an AMI for use in the Launch Template"
  default     = "amzn2-ami-ecs-hvm-2.0*"
}

variable "ami_architecture" {
  type        = string
  description = "Name of the OS Architecture. Note must be compatible with the selected EC2 Instance Type"
  default     = "x86_64"
}

variable "ec2_keypair" {
  type        = string
  description = "Name of EC2 Keypair for SSH access to EC2 instances"
  default     = null
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 Instance type used by EC2 Instances"
  default     = "t3.small"
}

variable "ec2_additional_userdata" {
  type        = string
  description = "Additional userdata to append to the launch template configuration"
  default     = ""
}

variable "ec2_ebs_volume_type" {
  type        = string
  description = "Volume type used in EBS volumes"
  default     = "gp3"
}

variable "asg_min_size" {
  type        = number
  description = "Minimum number of instances in the Autoscaling Group"
  default     = 1
}

variable "asg_max_size" {
  type        = number
  description = "Maximum number of instances in the Autoscaling Group"
  default     = 1
}

variable "asg_desired_capacity" {
  type        = number
  description = "Desired number of instances in the Autoscaling Group"
  default     = 1
}

variable "asg_default_cooldown" {
  type        = number
  description = "Number of seconds between scaling activities"
  default     = 300
}

variable "asg_health_check_type" {
  type        = string
  description = "Type of health check for the Autoscaling Group. Can be EC2 or ELB"
  default     = "EC2"
}

variable "asg_health_check_grace_period" {
  type        = number
  description = "Grace Period before health checks are enabled. ECS Services can take 10 minutes to stabilise"
  default     = 600
}

variable "asg_termination_policies" {
  type        = list(string)
  description = "Termination Policies used by the Autoscaling Group"
  default     = ["OldestLaunchTemplate"]
}

variable "asg_protect_from_scale_in" {
  type        = bool
  description = "Whether newly launched instances are automatically protected from termination"
  default     = true
}

variable "asg_metrics_granularity" {
  type        = string
  description = "Granularity of metrics collected by the Autoscaling Group"
  default     = "1Minute"
}

variable "asg_enabled_metrics" {
  type        = list(string)
  description = "List of metrics enabled for the Auotscaling Group"
  default = [
    "GroupTotalInstances",
    "GroupInServiceInstances",
    "GroupTerminatingInstances",
    "GroupPendingInstances",
    "GroupInServiceCapacity",
    "GroupPendingCapacity",
    "GroupTotalCapacity",
    "GroupTerminatingCapacity",
  ]
}

variable "ecs_capacity_provider_status" {
  type        = string
  description = "Enables or disables managed scaling on ASG"
  default     = "ENABLED"
}

variable "ecs_capacity_provider_target_capacity_percent" {
  type        = number
  description = "Percentage target capacity utilization for the autscaling group instances"
  default     = 100
}

variable "ecs_capacity_provider_managed_termination_protection" {
  type        = string
  description = "Enables or disables container-aware termination of instances in the ASG when scale-in happens"
  default     = "ENABLED"
}

variable "alb_internal" {
  type        = bool
  description = "Whether the ALB should be internal (not public facing)"
  default     = false
}

variable "alb_access_logs_enabled" {
  type        = bool
  description = "Whether to enable access logging for the ALB"
  default     = false
}

variable "alb_access_logs_bucket" {
  type        = string
  description = "Name of the S3 Bucket for ALB access logs"
  default     = ""
}

variable "alb_access_logs_prefix" {
  type        = string
  description = "Prefix for objects in S3 bucket for ALB access logs"
  default     = ""
}

variable "alb_idle_timeout" {
  type        = string
  description = "Idle timeout for load balancer"
  default     = "60"
}

variable "alb_enable_deletion_protection" {
  type        = bool
  description = "Whether to enable deletion protection for the ALB"
  default     = true
}

variable "alb_listener_ssl_policy" {
  type        = string
  description = "TLS security policy used by the default ALB Listener"
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "alb_listener_fixed_response_content_type" {
  type        = string
  description = "Default content type for the fixed response of the default ALB Listener"
  default     = "text/html"
}

variable "alb_listener_fixed_response_message_body" {
  type        = string
  description = "Default message body for the fixed response of the default ALB Listener"
  default     = "<!DOCTYPE html><body><h1>Hello World!</h1></body>"
}

variable "alb_listener_fixed_response_status_code" {
  type        = string
  description = "Default status code for the fixed response of the default ALB Listener"
  default     = "200"
}

variable "cloudwatch_log_group" {
  type        = string
  description = "Name of the cloudwatch log group"
}

variable "waf_use_ip_restrictions" {
  type        = bool
  description = "Whether to use IP range restrictions on the default WAF"
  default     = false
}

variable "waf_use_rate_limiting" {
  type        = bool
  description = "Whether to use rate limiting on the default WAF"
  default     = false
}

variable "waf_ip_set_addresses" {
  type        = list(string)
  description = "List of IPs for WAF IP Set Safelist"
  default     = ["131.111.0.0/16"]
}

variable "waf_rate_limit" {
  type        = number
  description = "The limit of requests from a single originating IP address"
  default     = 300
}

variable "waf_rate_limiting_aggregate_key_type" {
  type        = string
  description = "Indicates how to aggregate the request counts. Valid values include: CONSTANT, CUSTOM_KEYS, FORWARDED_IP, or IP"
  default     = "IP"
}

variable "waf_rate_limiting_evaluation_window" {
  type        = number
  description = "Number of seconds during which the WAF should count requests for rate limiting. Valid values are 60, 120, 300 and 600"
  default     = 120
}

variable "waf_rate_limiting_forwarded_header_name" {
  type        = string
  description = "Name of the HTTP header to use as an alternative for IP address matching"
  default     = "X-Forwarded-For"
}

variable "waf_rate_limiting_forwarded_fallback_behavior" {
  type        = string
  description = "Behaviour if a request does not contain the specified forwarded header"
  default     = "NO_MATCH"
}

variable "waf_use_bot_control" {
  type        = bool
  description = "Whether to use enhanced bot control on the WAF"
  default     = false
}

variable "waf_bot_control_enable_machine_learning" {
  type        = bool
  description = "Determines whether to use machine learning to analyze your web traffic for bot-related activity"
  default     = false
}

variable "waf_bot_control_inspection_level" {
  type        = string
  description = "The inspection level to use for the WAF Bot Control rule group. Must be one of COMMON or TARGETED"
  default     = "COMMON"
}

variable "acm_create_certificate" {
  type        = bool
  description = "Whether to create a certificate in Amazon Certificate Manager"
  default     = true
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN of an existing certificate in Amazon Certificate Manager"
  default     = null
}
