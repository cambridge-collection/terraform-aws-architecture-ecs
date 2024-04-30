variable "deployment_aws_region" {
  description = "The AWS region to deploy resources to"
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  type        = string
  description = "The environment you're working with. Live | Staging | Development | All"
  default     = "sandbox"
}

variable "project" {
  type        = string
  description = "Project or Service name, e.g. DPS, CUDL, Darwin"
}

variable "component" {
  type        = string
  description = "e.g. Deposit Service | All"
}

variable "subcomponent" {
  type        = string
  description = "If applicable: any value, e.g. Fedora"
}

variable "owner" {
  type        = string
  description = "Optional Owner tag. Your CRSid, e.g. jag245"
}

variable "cluster_name_suffix" {
  type        = string
  description = "Name suffix of the ECS Cluster"
}

variable "vpc_public_subnet_public_ip" {
  type        = bool
  description = "Whether to automatically assign public IP addresses in the public subnets"
}

variable "registered_domain_name" {
  type        = string
  description = "Registered Domain Name"
}

variable "route53_delegation_set_id" {
  type        = string
  description = "The ID of the reusable delegation set whose NS records should be assigned to the hosted zone"
}

variable "route53_zone_force_destroy" {
  type        = bool
  description = "Whether to destroy all records (possibly managed outside of Terraform) in the zone when destroying the zone"
}

variable "alb_enable_deletion_protection" {
  type        = bool
  description = "Whether to enable deletion protection for the ALB"
}

variable "cloudwatch_log_group" {
  type        = string
  description = "Name of the cloudwatch log group"
}
