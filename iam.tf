data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance" {
  path                 = "/"
  name                 = trimprefix(substr("${var.name_prefix}-instance-role", -64, -1), "-")
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy.json
  max_session_duration = 3600

  tags = {
    Name = "${var.name_prefix}-instance-role"
  }
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ec2_container_service" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "instance" {
  name = "${var.name_prefix}-instance-profile"
  role = aws_iam_role.instance.name
}

data "aws_iam_policy_document" "assume_role_policy_ecs" {
  count = var.ecs_capacity_provider_managed_instances ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "infrastructure" {
  count = var.ecs_capacity_provider_managed_instances ? 1 : 0

  path                 = "/"
  name                 = trimprefix(substr("${var.name_prefix}-infrastructure", -64, -1), "-")
  assume_role_policy   = data.aws_iam_policy_document.assume_role_policy_ecs.0.json
  max_session_duration = 3600

  tags = {
    Name = "${var.name_prefix}-infrastructure-role"
  }
}

# this is needed because the AmazonECSInfrastructureRolePolicyForManagedInstances policy
# limits the names of instance roles

data "aws_iam_policy_document" "infrastructure_extra" {
  count = var.ecs_capacity_provider_managed_instances ? 1 : 0

  statement {
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.instance.arn]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "infrastructure_extra" {
  count = var.ecs_capacity_provider_managed_instances ? 1 : 0

  name        = trimprefix(substr("${var.name_prefix}-infrastructure-extra", -64, -1), "-")
  path        = "/"
  description = "Additional permissions for ${aws_iam_role.infrastructure.0.name}"
  policy      = data.aws_iam_policy_document.infrastructure_extra.0.json
  tags = {
    Name = trimprefix(substr("${var.name_prefix}-infrastructure-extra", -64, -1), "-")
  }
}

resource "aws_iam_role_policy_attachment" "infrastructure" {
  count = var.ecs_capacity_provider_managed_instances ? 1 : 0

  role       = aws_iam_role.infrastructure.0.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECSInfrastructureRolePolicyForManagedInstances"
}

resource "aws_iam_role_policy_attachment" "infrastructure_extra" {
  count = var.ecs_capacity_provider_managed_instances ? 1 : 0

  role       = aws_iam_role.infrastructure.0.name
  policy_arn = aws_iam_policy.infrastructure_extra.0.arn
}
