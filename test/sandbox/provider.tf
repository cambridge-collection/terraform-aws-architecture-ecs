provider "aws" {
  region = var.deployment_aws_region

  default_tags {
    tags = local.default_tags
  }
}

locals {
  environment = strcontains(lower(var.environment), "sandbox") ? join("-", [var.owner, var.environment]) : var.environment
  default_tags = {
    Environment  = title(local.environment)
    Project      = var.project
    Component    = var.component
    Subcomponent = var.subcomponent
    Deployment   = var.cluster_name_suffix
    Source       = "https://github.com/cambridge-collection/terraform-aws-architecture-ecs"
    Owner        = var.owner
    terraform    = true
  }
}
