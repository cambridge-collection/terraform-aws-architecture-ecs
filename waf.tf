resource "aws_wafv2_ip_set" "this" {
  count = var.waf_use_ip_restrictions ? 1 : 0

  name               = "${var.name_prefix}-waf-ip-set"
  provider           = aws.us-east-1
  description        = "Managed by Terraform"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = var.waf_ip_set_addresses
}

resource "aws_wafv2_web_acl" "this" {
  name        = "${var.name_prefix}-waf-web-acl"
  provider    = aws.us-east-1
  description = "Managed by Terraform"
  scope       = "CLOUDFRONT"

  default_action {
    dynamic "block" {
      for_each = var.waf_use_ip_restrictions ? [1] : []
      content {}
    }

    dynamic "allow" {
      for_each = var.waf_use_ip_restrictions ? [] : [1]
      content {}
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 0

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    override_action {
      none {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

        rule_action_override {
          name = "SizeRestrictions_QUERYSTRING"
          action_to_use {
            allow {}
          }
        }

        rule_action_override {
          name = "SizeRestrictions_BODY"
          action_to_use {
            allow {}
          }
        }
      }
    }

    override_action {
      none {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 2

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    override_action {
      none {}
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  dynamic "rule" {
    for_each = var.waf_use_ip_restrictions ? [1] : []

    content {
      name     = "${var.name_prefix}-waf-web-acl-rule-ip-set"
      priority = 3

      action {
        allow {}
      }

      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.this.0.arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.name_prefix}-waf-web-acl-rule-ip-set"
        sampled_requests_enabled   = true
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.name_prefix}-waf-web-acl-no-rule"
    sampled_requests_enabled   = true
  }
}
