resource "aws_ecs_cluster" "this" {
  name = var.name_prefix
}

# NOTE this resource automatically creates an ECS managed Scaling Policy
# in the Auto Scaling Group
resource "aws_ecs_capacity_provider" "this" {
  name = "${var.name_prefix}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.this.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = var.ecs_capacity_provider_target_capacity_percent
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = [aws_ecs_capacity_provider.this.name]
}
