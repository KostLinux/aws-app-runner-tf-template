output "subnets" {
    description = "Subnets for the application"
    value = data.aws_subnets.private.ids
}

output "vpc_id" {
    description = "VPC ID for the application"
    value = data.aws_vpc.default.id
}

output "service_account_name" {
    description = "Service Account Name for the application"
    value = module.application_service_account.iam_role_name
}

output "service_account_arn" {
    description = "Service Account ARN for the application"
    value = module.application_service_account.iam_role_arn
}

output "route53_zone_arn" {
    description = "Route53 Zone ARN for the application"
    value = data.aws_route53_zone.existing_route53_zone.arn
}

output "route53_zone_id" {
    description = "Route53 Zone ID for the application"
    value = data.aws_route53_zone.existing_route53_zone.zone_id
}

output "route53_zone_name" {
    description = "Route53 Zone Name for the application"
    value = data.aws_route53_zone.existing_route53_zone.name
}

output "apprunner_service_id" {
    description = "App Runner Service ID for the application"
    value = module.example_app_runner.service_id
}

output "certificate_validation_records" {
    description = "Certificate Validation Records for the application"
    value = module.example_app_runner.custom_domain_association_certificate_validation_records
}
