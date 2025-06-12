resource "aws_cloudwatch_log_group" "this" {
  count = var.cloudwatch_log_group_exists ? 0 : 1

  name              = var.cloudwatch_log_group
  skip_destroy      = var.cloudwatch_log_group_skip_destroy
  retention_in_days = var.cloudwatch_log_group_retention_in_days
}
