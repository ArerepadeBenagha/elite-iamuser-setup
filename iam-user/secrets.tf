resource "aws_ssm_parameter" "secret" {
  name        = join("-", [local.application.app_name, "eliteadminuser_ssmsecrets"])
  description = "The parameter description"
  type        = "SecureString"
  value       = "6KBK4pH8W7x1W3wN"

  tags = local.common_tags
}