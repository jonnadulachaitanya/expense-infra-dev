locals {
  resource_name         = "${var.project_name}-${var.environment}-frontend"
  web_alb_listener_arn  = data.aws_ssm_parameter.web_alb_listener_arn.value
  https_certificate_arn = data.aws_ssm_parameter.https_certificate_arn.value
}
