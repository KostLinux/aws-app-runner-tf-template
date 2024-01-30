variable "route53_domain" {
    description = "Domain name registered in Route53"
    type        = string
    default     = ""
}

variable "app_sub_domain" {
    description = "Subdomain for the application"
    type        = string
    default     = "example-api"
}

variable "app_port" {
    description = "Port the application is listening on"
    type        = number
    default     = 8080
}

variable "app_repository" {
    description = "ECR repository name"
    type        = string
    default     = "example-api"
}

variable "app_image_tag" {
    description = "ECR image tag"
    type        = string
    default     = "latest"
}

variable "app_environment_variables" {
    description = "Environment variables for the application"
    type        = list(object({
        name  = string
        value = string
        description = string
    }))
    default     = []
}