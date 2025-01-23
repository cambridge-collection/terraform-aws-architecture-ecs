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
    for_each = var.waf_use_bot_control ? [1] : []
    content {
      name     = join("-", [var.name_prefix, "waf-web-bot-control"])
      priority = 3

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesBotControlRuleSet"
          vendor_name = "AWS"

          managed_rule_group_configs {
            aws_managed_rules_bot_control_rule_set {
              enable_machine_learning = var.waf_bot_control_enable_machine_learning
              inspection_level        = var.waf_bot_control_inspection_level
            }
          }
        }

        dynamic "not_statement" {
          for_each = var.waf_bot_control_exclusion_header != null ? [1] : []
          content {
            statement {
              byte_match_statement {
                search_string         = var.waf_bot_control_exclusion_header_value
                positional_constraint = var.waf_bot_control_exclusion_header_match_type
                field_to_match {
                  single_header {
                    name = var.waf_bot_control_exclusion_header
                  }
                }
                text_transformation {
                  type     = var.waf_bot_control_exclusion_header_text_transform
                  priority = 0
                }
              }
            }
          }
        }
      }

      override_action {
        none {}
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = join("-", [var.name_prefix, "waf-web-bot-control"])
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic "rule" {
    for_each = var.waf_use_rate_limiting ? [1] : []
    content {
      name     = "${var.name_prefix}-waf-web-acl-rule-rate-limiting"
      priority = 4

      action {
        block {}
      }

      statement {
        rate_based_statement {
          limit                 = var.waf_rate_limit
          aggregate_key_type    = var.waf_rate_limiting_aggregate_key_type
          evaluation_window_sec = var.waf_rate_limiting_evaluation_window

          dynamic "forwarded_ip_config" {
            for_each = var.waf_rate_limiting_aggregate_key_type == "FORWARDED_IP" ? [1] : []
            content {
              header_name       = var.waf_rate_limiting_forwarded_header_name
              fallback_behavior = var.waf_rate_limiting_forwarded_fallback_behavior
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.name_prefix}-waf-web-acl-rule-rate-limiting"
        sampled_requests_enabled   = true
      }
    }
  }

  dynamic "rule" {
    for_each = var.waf_use_ip_restrictions ? [1] : []

    content {
      name     = "${var.name_prefix}-waf-web-acl-rule-ip-set"
      priority = 5

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
