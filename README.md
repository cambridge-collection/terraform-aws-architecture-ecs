# Terraform Module for ECS Architecture

This Terraform module builds the base AWS infrastructure needed to support ECS Services. This module implements the architecture described below ![Architectural Diagram](./diagram.svg).

The module will by default build an Auto Scaling Group in private subnets. VPC Endpoints create links to AWS services that will allow the ECS Services to run, as well as accessing ECR repositories.

By default the `ec2_keypair` input is null, and no Security Group rules allow for SSH access. EC2 instances can be accessed using AWS Session Manager. 

In order to provide a running ECS Service, a child module will need to build it's own ECS Service and ECS Task Definition objects, in addition to an ECR Repository. It will not be possible to use publicly available container images as instances in private subnets will have no outbound route to the internet.

A child module will also need to create its own Load Balancer Listener and Load Balancer Target Group. The child module will need an `aws_autoscaling_attachment` resource to connect the target group to the Autoscaling Group created by this module. The attachment allows the Autoscaling Group to automatically register EC2 Instances with the target group.

To allow connectivity from the Internet, this module has been designed to operate through AWS CloudFront. This has not been implemented in this module as several CloudFront distributions may exist for the same ECS base architecture. The output `alb_dns_name` from this module can be used in the `domain_name` and `origin_id` arguments of a custom `origin` block in a `aws_cloudfront_distribution` resource in Terraform: this will direct requests from the CloudFront distribution to the public Application Load Balancer created by this module. This module also outputs a value `waf_acl_arn` that may be passed into the `web_acl_id` argument of a `aws_cloudfront_distribution` resource to protect the CloudFront distribution.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.50.0 |
| <a name="provider_aws.us-east-1"></a> [aws.us-east-1](#provider\_aws.us-east-1) | 5.50.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_autoscaling_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_default_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_ecs_capacity_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) | resource |
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_eip.nat_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip.nat_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ec2_container_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_managed_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_launch_template.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_nat_gateway.nat_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_nat_gateway.nat_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.cudl_vpc_ec2_route_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route53_delegation_set.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_delegation_set) | resource |
| [aws_route53_record.acm_validation_cname](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.dkim](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.dmarc_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.ses_verification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route_table.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.vpc_endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.alb_ingress_cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.asg_egress_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.vpc_endpoint_egress_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.vpc_endpoint_ingress_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.vpc_endpoints_egress_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ses_domain_dkim.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_dkim) | resource |
| [aws_ses_domain_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity) | resource |
| [aws_ses_domain_identity_verification.ses_verification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ses_domain_identity_verification) | resource |
| [aws_subnet.private_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_dhcp_options.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |
| [aws_vpc_endpoint.interface](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_peering_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_wafv2_ip_set.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_web_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_ami.ecs_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudwatch_log_group) | data source |
| [aws_ec2_managed_prefix_list.cloudfront](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_ec2_managed_prefix_list.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ec2_managed_prefix_list) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_alias.ebs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_alias) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.existing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_access_logs_bucket"></a> [alb\_access\_logs\_bucket](#input\_alb\_access\_logs\_bucket) | Name of the S3 Bucket for ALB access logs | `string` | `""` | no |
| <a name="input_alb_access_logs_enabled"></a> [alb\_access\_logs\_enabled](#input\_alb\_access\_logs\_enabled) | Whether to enable access logging for the ALB | `bool` | `false` | no |
| <a name="input_alb_access_logs_prefix"></a> [alb\_access\_logs\_prefix](#input\_alb\_access\_logs\_prefix) | Prefix for objects in S3 bucket for ALB access logs | `string` | `""` | no |
| <a name="input_alb_enable_deletion_protection"></a> [alb\_enable\_deletion\_protection](#input\_alb\_enable\_deletion\_protection) | Whether to enable deletion protection for the ALB | `bool` | `true` | no |
| <a name="input_alb_idle_timeout"></a> [alb\_idle\_timeout](#input\_alb\_idle\_timeout) | Idle timeout for load balancer | `string` | `"60"` | no |
| <a name="input_alb_internal"></a> [alb\_internal](#input\_alb\_internal) | Whether the ALB should be internal (not public facing) | `bool` | `false` | no |
| <a name="input_alb_listener_fixed_response_content_type"></a> [alb\_listener\_fixed\_response\_content\_type](#input\_alb\_listener\_fixed\_response\_content\_type) | Default content type for the fixed response of the default ALB Listener | `string` | `"text/html"` | no |
| <a name="input_alb_listener_fixed_response_message_body"></a> [alb\_listener\_fixed\_response\_message\_body](#input\_alb\_listener\_fixed\_response\_message\_body) | Default message body for the fixed response of the default ALB Listener | `string` | `"<!DOCTYPE html><body><h1>Hello World!</h1></body>"` | no |
| <a name="input_alb_listener_fixed_response_status_code"></a> [alb\_listener\_fixed\_response\_status\_code](#input\_alb\_listener\_fixed\_response\_status\_code) | Default status code for the fixed response of the default ALB Listener | `string` | `"200"` | no |
| <a name="input_alb_listener_ssl_policy"></a> [alb\_listener\_ssl\_policy](#input\_alb\_listener\_ssl\_policy) | TLS security policy used by the default ALB Listener | `string` | `"ELBSecurityPolicy-TLS13-1-2-2021-06"` | no |
| <a name="input_ami_architecture"></a> [ami\_architecture](#input\_ami\_architecture) | Name of the OS Architecture. Note must be compatible with the selected EC2 Instance Type | `string` | `"x86_64"` | no |
| <a name="input_ami_name_prefix"></a> [ami\_name\_prefix](#input\_ami\_name\_prefix) | Prefix used to find an AMI for use in the Launch Template | `string` | `"amzn2-ami-ecs-hvm-2.0*"` | no |
| <a name="input_asg_allow_all_egress"></a> [asg\_allow\_all\_egress](#input\_asg\_allow\_all\_egress) | Whether to allow EC2 instances in ASG egress to all targets | `bool` | `false` | no |
| <a name="input_asg_default_cooldown"></a> [asg\_default\_cooldown](#input\_asg\_default\_cooldown) | Number of seconds between scaling activities | `number` | `300` | no |
| <a name="input_asg_desired_capacity"></a> [asg\_desired\_capacity](#input\_asg\_desired\_capacity) | Desired number of instances in the Autoscaling Group | `number` | `1` | no |
| <a name="input_asg_enabled_metrics"></a> [asg\_enabled\_metrics](#input\_asg\_enabled\_metrics) | List of metrics enabled for the Auotscaling Group | `list(string)` | <pre>[<br>  "GroupTotalInstances",<br>  "GroupInServiceInstances",<br>  "GroupTerminatingInstances",<br>  "GroupPendingInstances",<br>  "GroupInServiceCapacity",<br>  "GroupPendingCapacity",<br>  "GroupTotalCapacity",<br>  "GroupTerminatingCapacity"<br>]</pre> | no |
| <a name="input_asg_health_check_grace_period"></a> [asg\_health\_check\_grace\_period](#input\_asg\_health\_check\_grace\_period) | Grace Period before health checks are enabled. ECS Services can take 10 minutes to stabilise | `number` | `600` | no |
| <a name="input_asg_health_check_type"></a> [asg\_health\_check\_type](#input\_asg\_health\_check\_type) | Type of health check for the Autoscaling Group. Can be EC2 or ELB | `string` | `"EC2"` | no |
| <a name="input_asg_max_size"></a> [asg\_max\_size](#input\_asg\_max\_size) | Maximum number of instances in the Autoscaling Group | `number` | `1` | no |
| <a name="input_asg_metrics_granularity"></a> [asg\_metrics\_granularity](#input\_asg\_metrics\_granularity) | Granularity of metrics collected by the Autoscaling Group | `string` | `"1Minute"` | no |
| <a name="input_asg_min_size"></a> [asg\_min\_size](#input\_asg\_min\_size) | Minimum number of instances in the Autoscaling Group | `number` | `1` | no |
| <a name="input_asg_protect_from_scale_in"></a> [asg\_protect\_from\_scale\_in](#input\_asg\_protect\_from\_scale\_in) | Whether newly launched instances are automatically protected from termination | `bool` | `true` | no |
| <a name="input_asg_termination_policies"></a> [asg\_termination\_policies](#input\_asg\_termination\_policies) | Termination Policies used by the Autoscaling Group | `list(string)` | <pre>[<br>  "OldestLaunchTemplate"<br>]</pre> | no |
| <a name="input_cloudwatch_log_group"></a> [cloudwatch\_log\_group](#input\_cloudwatch\_log\_group) | Name of the cloudwatch log group | `string` | n/a | yes |
| <a name="input_ec2_ebs_volume_type"></a> [ec2\_ebs\_volume\_type](#input\_ec2\_ebs\_volume\_type) | Volume type used in EBS volumes | `string` | `"gp3"` | no |
| <a name="input_ec2_instance_type"></a> [ec2\_instance\_type](#input\_ec2\_instance\_type) | EC2 Instance type used by EC2 Instances | `string` | `"t3.small"` | no |
| <a name="input_ec2_keypair"></a> [ec2\_keypair](#input\_ec2\_keypair) | Name of EC2 Keypair for SSH access to EC2 instances | `string` | `null` | no |
| <a name="input_ecs_capacity_provider_managed_termination_protection"></a> [ecs\_capacity\_provider\_managed\_termination\_protection](#input\_ecs\_capacity\_provider\_managed\_termination\_protection) | Enables or disables container-aware termination of instances in the ASG when scale-in happens | `string` | `"ENABLED"` | no |
| <a name="input_ecs_capacity_provider_status"></a> [ecs\_capacity\_provider\_status](#input\_ecs\_capacity\_provider\_status) | Enables or disables managed scaling on ASG | `string` | `"ENABLED"` | no |
| <a name="input_ecs_capacity_provider_target_capacity_percent"></a> [ecs\_capacity\_provider\_target\_capacity\_percent](#input\_ecs\_capacity\_provider\_target\_capacity\_percent) | Percentage target capacity utilization for the autscaling group instances | `number` | `100` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix of the ECS Cluster and associated resources | `string` | n/a | yes |
| <a name="input_route53_delegation_set_id"></a> [route53\_delegation\_set\_id](#input\_route53\_delegation\_set\_id) | The ID of the reusable delegation set whose NS records should be assigned to the hosted zone | `string` | `null` | no |
| <a name="input_route53_delegation_set_reference_name"></a> [route53\_delegation\_set\_reference\_name](#input\_route53\_delegation\_set\_reference\_name) | This is a reference name used in Caller Reference (helpful for identifying single delegation set amongst others) | `string` | `null` | no |
| <a name="input_route53_zone_domain_name"></a> [route53\_zone\_domain\_name](#input\_route53\_zone\_domain\_name) | Name of the Domain Name used by the Route 53 Zone. Trailing dots are ignored | `string` | `null` | no |
| <a name="input_route53_zone_force_destroy"></a> [route53\_zone\_force\_destroy](#input\_route53\_zone\_force\_destroy) | Whether to destroy the Route 53 Zone although records may still exist | `bool` | `false` | no |
| <a name="input_route53_zone_id_existing"></a> [route53\_zone\_id\_existing](#input\_route53\_zone\_id\_existing) | ID of an existing Route 53 Hosted zone as an alternative to creating a hosted zone | `string` | `null` | no |
| <a name="input_s3_bucket_force_destroy"></a> [s3\_bucket\_force\_destroy](#input\_s3\_bucket\_force\_destroy) | Whether to allow a non-empty bucket to be destroyed | `bool` | `false` | no |
| <a name="input_s3_bucket_versioning_enabled"></a> [s3\_bucket\_versioning\_enabled](#input\_s3\_bucket\_versioning\_enabled) | Whether to enable S3 bucket versioning | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags for adding to resources | `map(string)` | `{}` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_vpc_endpoint_dns_record_ip_type"></a> [vpc\_endpoint\_dns\_record\_ip\_type](#input\_vpc\_endpoint\_dns\_record\_ip\_type) | The DNS records created for the endpoint | `string` | `"ipv4"` | no |
| <a name="input_vpc_endpoint_services"></a> [vpc\_endpoint\_services](#input\_vpc\_endpoint\_services) | List of services to create VPC Endpoints for | `list(string)` | <pre>[<br>  "ssmmessages",<br>  "ssm",<br>  "ec2messages",<br>  "ecr.api",<br>  "ecr.dkr",<br>  "ecs",<br>  "ecs-agent",<br>  "ecs-telemetry",<br>  "logs"<br>]</pre> | no |
| <a name="input_vpc_peering_vpc_ids"></a> [vpc\_peering\_vpc\_ids](#input\_vpc\_peering\_vpc\_ids) | List of VPC IDS for peering with the VPC | `list(string)` | `[]` | no |
| <a name="input_vpc_public_subnet_public_ip"></a> [vpc\_public\_subnet\_public\_ip](#input\_vpc\_public\_subnet\_public\_ip) | Whether to automatically assign public IP addresses in the public subnets | `bool` | `false` | no |
| <a name="input_waf_ip_set_addresses"></a> [waf\_ip\_set\_addresses](#input\_waf\_ip\_set\_addresses) | List of IPs for WAF IP Set Safelist | `list(string)` | <pre>[<br>  "131.111.0.0/16"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_arn"></a> [alb\_arn](#output\_alb\_arn) | ARN of the Application Load Balancer |
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | DNS Name of the Application Load Balancer |
| <a name="output_alb_https_listener_arn"></a> [alb\_https\_listener\_arn](#output\_alb\_https\_listener\_arn) | ARN of the default Application Load Balancer Listener on port 443 |
| <a name="output_alb_security_group_id"></a> [alb\_security\_group\_id](#output\_alb\_security\_group\_id) | ID of the Security Group for the Application Load Balancer |
| <a name="output_asg_name"></a> [asg\_name](#output\_asg\_name) | Name of the Auto Scaling Group |
| <a name="output_asg_security_group_id"></a> [asg\_security\_group\_id](#output\_asg\_security\_group\_id) | ID of the Security Group for the Auto Scaling Group |
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | ARN of the CloudWatch Log Group |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output\_cloudwatch\_log\_group\_name) | Name of the CloudWatch Log Group |
| <a name="output_ecs_capacity_provider_name"></a> [ecs\_capacity\_provider\_name](#output\_ecs\_capacity\_provider\_name) | Name of the ECS Capacity Provider associated with the Autoscaling Group |
| <a name="output_ecs_cluster_arn"></a> [ecs\_cluster\_arn](#output\_ecs\_cluster\_arn) | ARN of the ECS Cluster |
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | Name of the ECS Cluster |
| <a name="output_route53_public_hosted_zone"></a> [route53\_public\_hosted\_zone](#output\_route53\_public\_hosted\_zone) | Zone ID of the Route 53 Public Hosted Zone |
| <a name="output_s3_bucket"></a> [s3\_bucket](#output\_s3\_bucket) | Name of the S3 Bucket |
| <a name="output_s3_bucket_arn"></a> [s3\_bucket\_arn](#output\_s3\_bucket\_arn) | ARN of the S3 Bucket |
| <a name="output_vpc_endpoint_security_group_id"></a> [vpc\_endpoint\_security\_group\_id](#output\_vpc\_endpoint\_security\_group\_id) | ID of the Security Group for VPC Endpoints |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
| <a name="output_vpc_private_subnet_ids"></a> [vpc\_private\_subnet\_ids](#output\_vpc\_private\_subnet\_ids) | Private Subnet IDs |
| <a name="output_vpc_public_subnet_ids"></a> [vpc\_public\_subnet\_ids](#output\_vpc\_public\_subnet\_ids) | Public Subnet IDs |
| <a name="output_waf_acl_arn"></a> [waf\_acl\_arn](#output\_waf\_acl\_arn) | ARN of the WAF Web ACL |
