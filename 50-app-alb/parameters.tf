
resource "aws_ssm_parameter" "aws_lb_listener" {
  name  = "/${var.project_name}/${var.environment}/app_alb_listener"
  type  = "StringList"
  value = aws_lb_listener.http.arn
}
