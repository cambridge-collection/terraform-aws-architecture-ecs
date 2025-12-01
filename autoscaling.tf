resource "aws_autoscaling_group" "this" {
  count = var.ecs_capacity_provider_managed_instances ? 0 : 1

  name = "${var.name_prefix}-asg"
  launch_template {
    id      = aws_launch_template.this.0.id
    version = "$Latest"
  }
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  default_cooldown          = var.asg_default_cooldown
  health_check_type         = var.asg_health_check_type
  health_check_grace_period = var.asg_health_check_grace_period
  vpc_zone_identifier       = aws_subnet.private.*.id
  termination_policies      = var.asg_termination_policies
  service_linked_role_arn   = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling" // AWS standard role
  metrics_granularity       = var.asg_metrics_granularity
  enabled_metrics           = var.asg_enabled_metrics
  protect_from_scale_in     = var.asg_protect_from_scale_in

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = var.name_prefix
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    ignore_changes = [
      target_group_arns, # NOTE this field will be updated by addition of aws_autoscaling_attachment resources
      desired_capacity   # NOTE this field will be updated by the ECS cluster capacity provider
    ]
  }
}

resource "aws_launch_template" "this" {
  count = var.ecs_capacity_provider_managed_instances ? 0 : 1

  name          = "${var.name_prefix}-lt"
  instance_type = var.ec2_instance_type
  image_id      = data.aws_ami.ecs_ami.image_id
  vpc_security_group_ids = var.vpc_endpoints_create ? [
    aws_security_group.asg.id,
    aws_security_group.vpc_endpoints.0.id
    ] : [
    aws_security_group.asg.id,
    aws_security_group.vpc_egress.0.id
  ]
  key_name               = var.ec2_keypair
  update_default_version = true
  user_data = base64encode(templatefile("${path.module}/userdata.sh.ttfpl", {
    ecs_cluster           = aws_ecs_cluster.this.name
    additional_userdata   = var.ec2_additional_userdata
    additional_ecs_config = var.ec2_additional_ecs_config
  }))

  iam_instance_profile {
    arn = aws_iam_instance_profile.instance.arn
  }

  # encrypt all EBS volumes
  dynamic "block_device_mappings" {
    for_each = data.aws_ami.ecs_ami.block_device_mappings
    content {
      device_name = block_device_mappings.value.device_name
      ebs {
        volume_size = block_device_mappings.value.ebs.volume_size
        volume_type = var.ec2_ebs_volume_type # override default for AMI
        encrypted   = true
        kms_key_id  = data.aws_kms_alias.ebs.target_key_arn
      }
    }
  }

  monitoring {
    enabled = true
  }
}
