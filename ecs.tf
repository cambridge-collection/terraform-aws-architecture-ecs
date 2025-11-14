resource "aws_ecs_cluster" "this" {
  name = var.name_prefix
}

# NOTE this resource automatically creates an ECS managed Scaling Policy
# in the Auto Scaling Group
resource "aws_ecs_capacity_provider" "this" {
  name    = "${var.name_prefix}-capacity-provider"
  cluster = var.ecs_capacity_provider_managed_instances ? aws_ecs_cluster.this.name : null

  dynamic "auto_scaling_group_provider" {
    for_each = var.ecs_capacity_provider_managed_instances ? [] : [1]

    content {
      auto_scaling_group_arn         = aws_autoscaling_group.this.0.arn
      managed_termination_protection = var.ecs_capacity_provider_managed_termination_protection

      managed_scaling {
        maximum_scaling_step_size = 2
        minimum_scaling_step_size = 1
        status                    = var.ecs_capacity_provider_status
        target_capacity           = var.ecs_capacity_provider_target_capacity_percent
      }
    }
  }

  dynamic "managed_instances_provider" {
    for_each = var.ecs_capacity_provider_managed_instances ? [1] : [0]

    content {
      infrastructure_role_arn = aws_iam_role.infrastructure.0.arn
      propagate_tags          = "CAPACITY_PROVIDER"

      instance_launch_template {
        ec2_instance_profile_arn = aws_iam_instance_profile.instance.arn
        instance_requirements {
          burstable_performance = var.ecs_managed_instances_include_burstable ? "included" : "excluded"

          memory_mib {
            min = var.ecs_managed_instances_memory_min
            max = var.ecs_managed_instances_memory_max
          }

          vcpu_count {
            min = var.ecs_managed_instances_vcpu_min
            max = var.ecs_managed_instances_vcpu_max
          }
        }

        network_configuration {
          security_groups = var.vpc_endpoints_create ? [
            aws_security_group.asg.id,
            aws_security_group.vpc_endpoints.0.id
            ] : [
            aws_security_group.asg.id,
            aws_security_group.vpc_egress.0.id
          ]
          subnets = aws_subnet.private.*.id
        }

        storage_configuration {
          storage_size_gib = var.ecs_managed_instances_storage_size
        }
      }
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = [aws_ecs_capacity_provider.this.name]

  default_capacity_provider_strategy {
    base              = var.ecs_default_capacity_provider_strategy_base
    weight            = var.ecs_default_capacity_provider_strategy_weight
    capacity_provider = aws_ecs_capacity_provider.this.name
  }
}
