
resource "aws_ssm_parameter" "aws_alb_listener_arn" {
  name  = "/${var.project_name}/${var.environment}/app_alb_listener_arn"
  type  = "StringList"
  value = aws_lb_listener.http.arn
}
