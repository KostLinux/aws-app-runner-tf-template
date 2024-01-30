resource "aws_wafv2_ip_set" "ip_list" {
  name               = "example_office_ipset"
  description        = "Allow list for office"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  addresses = [
    "1.1.1.1/32",
  ]
}

resource "aws_wafv2_web_acl" "app_runner_acl" {
  name        = "example_app_runner_waf"
  description = "WebACL for AWS App Runner"
  scope       = "REGIONAL"

  default_action {
    block {}
  }

  // Rate Limits
  // https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl
  rule {
    name     = "example_rate_limits"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 1000
        aggregate_key_type = "IP"

        scope_down_statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.ip_list.arn
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AppRunnerRateLimits"
      sampled_requests_enabled   = false
    }
  }

  // IP Whitelist
  rule {
    name     = "allow_from_office"
    priority = 2

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ip_list.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AppRunnerAllowIPList"
      sampled_requests_enabled   = false
    }
  }

  // Bot protection
  rule {
    name     = "AWSManagedRulesBotControlRuleSet"
    priority = 10

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "aws_waf_all_requests"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "example" {
  resource_arn = module.example_app_runner.service_arn
  web_acl_arn  = aws_wafv2_web_acl.app_runner_acl.arn
  depends_on = [
      module.example_app_runner,
      aws_wafv2_ip_set.ip_list
  ]
}