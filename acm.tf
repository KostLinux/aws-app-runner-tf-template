module "acm" {
  source   = "terraform-aws-modules/acm/aws"
  version  = "~> 5.0"

  
  # Domain Name from infra_variables.tfvars
  domain_name = var.route53_domain
  zone_id     = data.aws_route53_zone.existing_route53_zone.zone_id

  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.route53_domain}"
  ]

  wait_for_validation = false

  tags = {
    Name = var.route53_domain
  }
  depends_on = [
    data.aws_route53_zone.existing_route53_zone
  ]
}