
# Example AWS App Runner Terraform Template

A production-ready AWS App Runner repository template with Terraform.

Feel free to make a pull request or issue if you have any suggestions or improvements.
## Features

- WAF Rate Limiting
- WAF IP Allow List
- IAM Service Account
- Automatic HTTPS with ACM + DNS Validation
- Custom Domain for AWS App Runner
- AWS App Runner Service
- Security Groups
- Makefile for faster development
- S3 Backend with encryption

## Prerequisites

- [S3 Bucket configured](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
- [ECR repository configured](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html)
- Application image built and pushed to ECR
- [Route53 Domain Zone registered](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/domain-register.html)
- Subnets contain tags for [data.aws_subnets.private](./data.tf)
- [TFLint](https://github.com/terraform-linters/tflint)
- [TFSec](https://github.com/aquasecurity/tfsec)

## Make functions available

- make deploy - Same as terraform apply
- make destroy - Same as terraform destroy
- make docs - Generates Readme documentation
- make format - Formates terraform files
- make init - Initialises terraform modules, providers and backend connection
- make plan - Same as terraform plan
- make validate - Validates terraform code quality and style
- make tfsec - Validate possible vulnerabilites in code
- make tflint - Validate terraform code style

## Getting Started

Before we're going to deep dive, let's explain, why we need to separate variables.

There's some general variables that are getting changed continuously or are used in multiple files. These variables are located under env/variables.tfvars.example

Also terraform needs an connection with AWS and S3 Backend to store Terraform state. These variables are located under .env.example.

**1. Clone this repository**

```
git clone git@github.com:KostLinux/aws-app-runner-tf-template.git & cd aws-app-runner-tf-template
```

**2. Configure connection with AWS and S3 Backend via .env**

Configure connection with AWS and S3 Backend to store Terraform state.

```
cp .env.example .env
```

**3. Configure Terraform variables via terraform.tfvars**

```
cp env/variables.tfvars.example env/variables.tfvars

vim env/variables.tfvars
```

**4. Make necessary changes in other .tf files via IDE**

Due to template repository, .tf files contain placeholders that should be replaced with real values.

```
# VsCode
code .

# Atom
atom .
```

**5. Validate code**

```
make validate
```

**6. Initialize Terraform**

```
make init
```

**7. Make terraform plan file**

```
make plan
```

**8. Apply changes**

```
make apply
```

**9. Push changes to git**

## Setting up pipeline

This repository contains workflow of feature-branches, when PR is merged, github actions deploy changes to AWS.

**1. Configure secrets**

Configure secrets in Settings -> Secrets and Variables -> Actions -> Environment Secrets

- TEST_AWS_ACCESS_KEY_ID - AWS Access Key ID for testing environment
- TEST_AWS_SECRET_ACCESS_KEY - AWS Secret Access Key for testing environment
- TEST_AWS_REGION - AWS Region for testing environment
- TEST_BUCKET_TF_STATE - S3 Bucket for testing environment
- TEST_KEY_TF_STATE - S3 Key for testing environment

- MAIN_AWS_ACCESS_KEY_ID - AWS Access Key ID for production environment
- MAIN_AWS_SECRET_ACCESS_KEY - AWS Secret Access Key for production environment
- MAIN_AWS_REGION - AWS Region for production environment
- MAIN_BUCKET_TF_STATE - S3 Bucket for production environment
- MAIN_KEY_TF_STATE - S3 Key for production environment

**2. Create example branch & push changes**

```
git checkout -b "test/try-pipeline"
git commit -m "Trigger a pipeline"
git push --set-upstream origin test/try-pipeline
```

**3. Create PR, merge into test and look into Github Actions**

Enjoy!

## License

This project is under [MIT License](./LICENSE.md)

## Author

[KostLinux](https://github.com/KostLinux) - Getting Error after error :S

______
## Terraform Reference

Terraform reference shows all the providers and modules used in this repository

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.34.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | ~> 4.0 |
| <a name="module_application_service_account"></a> [application\_service\_account](#module\_application\_service\_account) | terraform-aws-modules/iam/aws//modules/iam-assumable-role | ~> 5.32.0 |
| <a name="module_example_app_runner"></a> [example\_app\_runner](#module\_example\_app\_runner) | terraform-aws-modules/app-runner/aws | ~> 1.2.0 |
| <a name="module_iam_policy"></a> [iam\_policy](#module\_iam\_policy) | terraform-aws-modules/iam/aws//modules/iam-policy | ~> 5.32.0 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.example_app_runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.validation_records_app_runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.app_runner](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_wafv2_ip_set.ip_list](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set) | resource |
| [aws_wafv2_web_acl.app_runner_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |
| [aws_wafv2_web_acl_association.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.existing_route53_zone](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_environment_variables"></a> [app\_environment\_variables](#input\_app\_environment\_variables) | Environment variables for the application | <pre>list(object({<br>        name  = string<br>        value = string<br>        description = string<br>    }))</pre> | `[]` | no |
| <a name="input_app_image_tag"></a> [app\_image\_tag](#input\_app\_image\_tag) | ECR image tag | `string` | `"latest"` | no |
| <a name="input_app_port"></a> [app\_port](#input\_app\_port) | Port the application is listening on | `number` | `8080` | no |
| <a name="input_app_repository"></a> [app\_repository](#input\_app\_repository) | ECR repository name | `string` | `"example-api"` | no |
| <a name="input_app_sub_domain"></a> [app\_sub\_domain](#input\_app\_sub\_domain) | Subdomain for the application | `string` | `"example-api"` | no |
| <a name="input_route53_domain"></a> [route53\_domain](#input\_route53\_domain) | Domain name registered in Route53 | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apprunner_service_id"></a> [apprunner\_service\_id](#output\_apprunner\_service\_id) | App Runner Service ID for the application |
| <a name="output_certificate_validation_records"></a> [certificate\_validation\_records](#output\_certificate\_validation\_records) | Certificate Validation Records for the application |
| <a name="output_route53_zone_arn"></a> [route53\_zone\_arn](#output\_route53\_zone\_arn) | Route53 Zone ARN for the application |
| <a name="output_route53_zone_id"></a> [route53\_zone\_id](#output\_route53\_zone\_id) | Route53 Zone ID for the application |
| <a name="output_route53_zone_name"></a> [route53\_zone\_name](#output\_route53\_zone\_name) | Route53 Zone Name for the application |
| <a name="output_service_account_arn"></a> [service\_account\_arn](#output\_service\_account\_arn) | Service Account ARN for the application |
| <a name="output_service_account_name"></a> [service\_account\_name](#output\_service\_account\_name) | Service Account Name for the application |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Subnets for the application |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID for the application |

## Conclusion

This README is created via [terraform-docs](https://terraform-docs.io)


