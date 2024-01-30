// Setup App Runner
module "example_app_runner" {
  source = "terraform-aws-modules/app-runner/aws"
  version = "~> 1.2.0"

  service_name = "example_laravel_app"

  auto_scaling_configurations = {
    example_backend_autoscale = {
      name            = "example_application_autoscale"
      max_concurrency = 100
      max_size        = 8
      min_size        = 1
    }
  }
  # DNS
  create_custom_domain_association = true
  enable_www_subdomain = false
  domain_name = "${var.app_sub_domain}.${data.aws_route53_zone.existing_route53_zone.name}"

  instance_configuration = {
    cpu = 1024
    memory = 2048
  }

  source_configuration = {
    authentication_configuration = {
      access_role_arn = module.application_service_account.iam_role_arn
    }
    auto_deployments_enabled = true
    image_repository = {
      image_configuration = {
        port                          = var.app_port
        runtime_environment_variables = merge(
          { for env in var.app_environment_variables : env.name => env.value },
        )
      }
      image_identifier      = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${var.app_repository}:${var.app_image_tag}"
      image_repository_type = "ECR"
    }
  }
  # Network

  # Connect App Runner to Private subnets and allow outbound traffic
  create_vpc_connector = true
  vpc_connector_subnets = data.aws_subnets.private.ids
  vpc_connector_security_groups = [
    aws_security_group.app_runner.id
  ]

  network_configuration = {
    ingress_configuration = {
      is_publicly_accessible = true
    }
    egress_configuration = {
      egress_type = "VPC"
    }
  }

  # Monitoring
  enable_observability_configuration = true

  # IAM
  create_access_iam_role = false
  create_instance_iam_role = false

  access_iam_role_name = module.application_service_account.iam_role_name
  instance_iam_role_name = module.application_service_account.iam_role_name

  # Health Check
  health_check_configuration = {
    protocol = "TCP"
    path     = "/"
    healthy_threshold = 1
    unhealthy_threshold = 5
    interval = 10
    timeout = 5
  }
  tags = {
    ManagedBy = "Terraform"
  }

  depends_on = [
    data.aws_subnets.private,
    module.iam_policy,
    module.application_service_account,
    data.aws_vpc.default
  ]
}